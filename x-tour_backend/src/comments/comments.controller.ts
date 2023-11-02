import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Req, Query, } from '@nestjs/common';
import { CommentsService } from './comments.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { AuthGuard } from '@nestjs/passport';
import { query } from 'express';


@Controller('comments')
export class CommentsController {
  constructor(private readonly commentsService: CommentsService) {}

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async create(@Body() createCommentDto: CreateCommentDto,@Req() req) {
    const id=req.user['id']
    return await this.commentsService.createComment(createCommentDto,id);
  }


  @Get('/:id')
  async findOne(@Param('id') id: string) {
    return await this.commentsService.findOne(id);
  }
  
  @Get('post/:postId')
  async getComments(@Param('postId') postId: String, @Query() query){
    return await this.commentsService.getComment(postId,query);
  }

  @Get('replies/:replyId')
  async getReply(@Param('replyId') replyId, @Query() query){
    return await this.commentsService.getReply(replyId,query);

  }
  @UseGuards(AuthGuard('jwt'))
  @Patch('commentLike/:commentId')
  commentlike(
    @Param('commentId') commentId ,
    @Req() req
  ){
    const userId=req.user['id']
    return this.commentsService.commentLike(commentId, userId)
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('commentUnlike/:commentId')
  commentunlike(
    @Param('commentId') commentId ,
    @Req() req
  ){
    const userId=req.user['id']
    return this.commentsService.commentUnlike(commentId, userId)
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('replyLike/:replyId')
  replylike(
    @Param('replyId') replyId ,
    @Req() req
  ){
    const userId=req.user['id']
    return this.commentsService.replyLike(replyId, userId)
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('replyUnlike/:replyId')
  replyunlike(
    @Param('replyId') replyId ,
    @Req() req
  ){
    const userId=req.user['id']
    return this.commentsService.replyUnlike(replyId, userId)
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('/:id')
  update(@Param('id') id: string, @Body() updateCommentDto: UpdateCommentDto,@Req() req) {
    const userid=req.user['id']
    return this.commentsService.update(id, updateCommentDto,userid);
  }

  @UseGuards(AuthGuard('jwt'))
  @Delete('/:id')
  remove(@Param('id') id: string, @Req() req) {
    const userId=req.user['id']
    return this.commentsService.remove(id,userId);
  }
}
