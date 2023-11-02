import { Module, MiddlewareConsumer } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PostsModule } from './posts/posts.module';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';
import { join } from 'path';
import { JournalModule } from './journal/journal.module';
import { CommentsModule } from './comments/comments.module';
import { MongooseModule } from '@nestjs/mongoose';

import * as express from "express";
@Module({
  imports: [
    MongooseModule.forRoot('mongodb://127.0.0.1:27017/xTour', {
      useUnifiedTopology: true,
      useNewUrlParser: true,
    }),
    PostsModule,
    CommentsModule,
    UserModule,
    AuthModule,
    JournalModule,
   
  ],
  controllers: [AppController],
  providers: [AppService, 
  
],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer){
    consumer
      .apply(express.static(join(__dirname, "..", "images/imagess")))
      .forRoutes("*");
    consumer
      .apply(express.static(join(__dirname, "..", "images/Approved")))
      .forRoutes("*");
    consumer
      .apply(express.static(join(__dirname, "..", "images/pending")))
      .forRoutes("*");
  
  }
}