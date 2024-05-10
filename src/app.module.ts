import { Module } from '@nestjs/common';
import { CatsModule } from './api/cats/cats.module';

@Module({
  imports: [CatsModule],
})
export class AppModule { }
