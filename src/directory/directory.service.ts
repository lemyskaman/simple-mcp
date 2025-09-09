import { Injectable } from '@nestjs/common';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

@Injectable()
export class DirectoryService {
  
  /**
   * Lista el contenido de un directorio usando Git Bash y el comando ls
   * @param path Ruta del directorio a listar
   * @returns Contenido del directorio como string
   */
  async listDirectory(path: string): Promise<string> {
    try {
      // Validar que la ruta no esté vacía
      if (!path || path.trim() === '') {
        throw new Error('Path cannot be empty');
      }

      // Handle MCPHost path corruption systematically
      // Input: C:\\\\Users\\\\lemys\\\\.\\\\lopez\\\\projects\\\\fusable  
      // Should become: C:\Users\lemys.lopez\projects\fusable
      
      let cleanPath = path;
      
      // Step 1: Fix the escaped backslashes from JSON 
      // \\\\ becomes \\, \\\\. becomes \\.\\\\
      cleanPath = cleanPath.replace(/\\\\/g, '\\');
      
      // Step 2: Fix MCPHost path corruption where \.\ should just be .
      // The pattern: lemys\.\lopez should become lemys.lopez
      cleanPath = cleanPath.replace(/\\\.\\/g, '.');
      
      // Step 3: Convert to forward slashes for Git Bash, but handle Windows drive paths correctly
      cleanPath = cleanPath.replace(/\\/g, '/');
      
      // Step 4: Fix the issue where /c:/Users becomes c:/Users (remove leading slash from drive paths)
      cleanPath = cleanPath.replace(/^\/([a-zA-Z]:)/, '$1');
      
      // Remove quotes
      cleanPath = cleanPath.replace(/['"]/g, '');
      
      // Handle current directory
      if (cleanPath === '' || cleanPath === '/' || cleanPath === './') {
        cleanPath = '.';
      }
      
      console.error(`Original path: ${path}`);
      console.error(`Cleaned path: ${cleanPath}`);
      
      const sanitizedPath = cleanPath;
      
      // Ejecutar el comando ls usando Git Bash
      // Git Bash está generalmente ubicado en C:\Program Files\Git\bin\bash.exe
      const gitBashPath = 'C:\\Program Files\\Git\\bin\\bash.exe';
      const command = `"${gitBashPath}" -c "ls -la '${sanitizedPath}'"`;
      
      console.error(`Executing command: ${command}`);
      
      const { stdout, stderr } = await execAsync(command, {
        timeout: 10000, // 10 segundos de timeout
        maxBuffer: 1024 * 1024, // 1MB buffer máximo
      });

      if (stderr && stderr.trim() !== '') {
        console.error(`Command stderr: ${stderr}`);
        // Solo lanzar error si stderr contiene errores reales, no warnings
        if (stderr.toLowerCase().includes('error') || stderr.toLowerCase().includes('no such file')) {
          throw new Error(`Command error: ${stderr}`);
        }
      }

      return stdout || 'Directory is empty or no output returned';
      
    } catch (error) {
      console.error('Error in listDirectory:', error);
      
      // Intentar con cmd como fallback si Git Bash falla
      if (error.message.includes('spawn') || error.message.includes('not found')) {
        console.error('Git Bash not found, trying with PowerShell dir command as fallback');
        return this.listDirectoryFallback(path);
      }
      
      throw new Error(`Failed to list directory: ${error.message}`);
    }
  }

  /**
   * Fallback: usar PowerShell dir como alternativa si Git Bash no está disponible
   */
  private async listDirectoryFallback(path: string): Promise<string> {
    try {
      const sanitizedPath = path.replace(/[;&|`$()]/g, '`$&');
      const command = `powershell -Command "Get-ChildItem -Path '${sanitizedPath}' | Format-Table -AutoSize"`;
      
      console.error(`Executing fallback command: ${command}`);
      
      const { stdout, stderr } = await execAsync(command, {
        timeout: 10000,
        maxBuffer: 1024 * 1024,
      });

      if (stderr && stderr.trim() !== '') {
        console.error(`Fallback command stderr: ${stderr}`);
        if (stderr.toLowerCase().includes('error')) {
          throw new Error(`Fallback command error: ${stderr}`);
        }
      }

      return stdout || 'Directory is empty or no output returned';
      
    } catch (error) {
      throw new Error(`Fallback command failed: ${error.message}`);
    }
  }
}
