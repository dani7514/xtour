import { Module } from '@nestjs/common';
import { PostsService } from './posts.service';
import { PostsController } from './posts.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { postSchema } from './model/post.model';
import { MulterModule } from '@nestjs/platform-express';
import { PendingPostSchema as PendingPostSchema } from './model/penndingPost.model';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [MongooseModule.forFeature([{name: 'Post', schema: postSchema},{name: 'Pending', schema: PendingPostSchema}]), MulterModule.register({dest:'./images'}), UserModule],
  controllers: [PostsController],
  providers: [PostsService,],
  exports: [PostsService]
})
export class PostsModule {}
