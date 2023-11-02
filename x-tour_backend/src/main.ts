import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { AppModule } from './app.module';
import express from 'express';


async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule,{cors: true});
  app.useStaticAssets(join(__dirname, '../images'))
  await app.listen(3000);
}
bootstrap();
