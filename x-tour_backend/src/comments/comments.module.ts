import { Module } from '@nestjs/common';
import { CommentsService } from './comments.service';
import { CommentsController } from './comments.controller';
import { CommentSchema } from './Schemas/comments.schema';
import { Schema } from 'mongoose';
import {MongooseModule} from '@nestjs/mongoose';
import { PostsModule } from 'src/posts/posts.module';

@Module({
  imports: [
    MongooseModule.forFeature([{name:'Comments',schema:CommentSchema}]),
    PostsModule
  ],
  controllers: [CommentsController],
  providers: [CommentsService]
})
export class CommentsModule {}
