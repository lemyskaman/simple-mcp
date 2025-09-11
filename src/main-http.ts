import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as cors from 'cors';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable trust proxy for proper host header handling
  app.getHttpAdapter().getInstance().set('trust proxy', true);

  // Add middleware to handle Host header validation
  app.use((req, res, next) => {
    // Allow any host for MCP connections
    const allowedHosts = ['127.0.0.1:3000', 'localhost:3000', '0.0.0.0:3000'];
    const hostHeader = req.get('Host');
    
    if (hostHeader && !allowedHosts.includes(hostHeader)) {
      console.log(`Warning: Unusual host header: ${hostHeader}`);
    }
    
    next();
  });

  // Enable CORS with proper headers for MCP
  app.use(cors({
    origin: '*', // Configure appropriately for production
    exposedHeaders: ['Mcp-Session-Id'],
    allowedHeaders: ['Content-Type', 'mcp-session-id', 'Host'],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  }));

  const port = process.env.PORT || 3000;
  await app.listen(port, '0.0.0.0');
  
  console.log(`🚀 Simple MCP HTTP Server running on http://0.0.0.0:${port}`);
  console.log(`📡 MCP endpoint available at http://localhost:${port}/mcp`);
  console.log(`🧪 Test endpoint available at http://localhost:${port}/directory/list`);
}

bootstrap().catch((error) => {
  console.error('❌ Error starting HTTP server:', error);
  process.exit(1);
});
