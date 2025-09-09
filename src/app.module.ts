import { Module } from '@nestjs/common';
import { DirectoryModule } from './directory/directory.module';

@Module({
  imports: [DirectoryModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
