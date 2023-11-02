import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { InjectModel } from '@nestjs/mongoose';
import { Comments } from './Schemas/comments.schema';
import { Model } from 'mongoose';
import { PostsService } from 'src/posts/posts.service';

@Injectable()
export class CommentsService {
  constructor(
    @InjectModel('Comments') private readonly commentsModel: Model<Comments>,
    private readonly postService: PostsService

  ) {}
  async createComment(createCommentDto: CreateCommentDto,id: string) {
    const { replyId, postId, message } = createCommentDto;

    const comment= await this.commentsModel.create({
      commenterId: id,
      replyId,
      postId,
      message,
    });
     await comment.populate("commenterId");
     await this.postService.comments(comment.id , comment.postId)
     return comment
  }

  async getReply(replyId: String, query) {
    const {perPage = 20, page = 1 } = query;
    const skip = perPage * (page - 1);
    // const pages: number = parseInt(page as any) || 1;
    // const limit = 5;
    const replies = await this.commentsModel
      .find({ replyId: replyId })
      .skip(skip)
      .limit(perPage)
      .populate("commenterId")
      .exec();
    if (!replies) throw new NotFoundException('replies not found');

    return replies;
  }

  async getComment(postId: String,query) {
    const {perPage = 20, page = 1 } = query;
    const skip = perPage * (page - 1);

    const comments = await this.commentsModel.find({ postId: postId })
        .skip(skip)
        .limit(perPage)
        .populate("commenterId")
        .exec();

    if (!comments) throw new NotFoundException('comments not found');
    return comments;
  }

  async findOne(id: String) {
    const comment = await this.commentsModel.findById(id).populate("commenterId");

    if (!comment) throw new NotFoundException('Course Not Found');
    return comment;
  }

  async update(id: String, updateComment: UpdateCommentDto, userId: string) {
    const getComment= await this.commentsModel.findById(id);
    const commenterId = getComment.commenterId as unknown;
    if (commenterId.toString() === userId){
      return (await this.commentsModel.findByIdAndUpdate(id, updateComment,{returnOriginal: false})).populated("commenterId");
    }else{
      throw new BadRequestException("Cannot update other's comment");
    }
  }

  async remove(id: String, userId: string) {
    const comment = await this.commentsModel.findById(id);

    if (!comment) {
      throw new NotFoundException('Comment not found');
    }

    const commenterId = comment.commenterId as unknown;
    
    if  (commenterId.toString() === userId){
      await this.commentsModel.findByIdAndDelete(id);
      await this.commentsModel.deleteMany({ replyId: id });
    }
    else {
      throw new  BadRequestException("Cannot delete other's comment");
    }
    
  }

  async commentLike(commentId: string, userId: string) {
    return await this.commentsModel.findByIdAndUpdate(commentId,{$addToSet: {commentLikes: userId}},{returnOriginal: false})
    
  }
  async commentUnlike(commentId: string , userId: string){
    return await this.commentsModel.findByIdAndUpdate(commentId,{$pull: {replyLikes: userId}},{returnOriginal: false})
  }

  async replyLike(replyId: string, userId: string) {
    return await this.commentsModel.findByIdAndUpdate(replyId,{$addToSet: {replyLikes: userId}},{returnOriginal: false})
    
  }
  async replyUnlike(replyId: string , userId: string){
    return await this.commentsModel.findByIdAndUpdate(replyId,{$pull: {replyLikes: userId}},{returnOriginal: false})
  }
}
