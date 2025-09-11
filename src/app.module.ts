import { Module } from '@nestjs/common';
import { DirectoryModule } from './directory/directory.module';
import { McpModule } from './mcp/mcp.module';
import { RootMcpController } from './root-mcp.controller';

@Module({
  imports: [DirectoryModule, McpModule],
  controllers: [RootMcpController],
  providers: [],
})
export class AppModule {}
