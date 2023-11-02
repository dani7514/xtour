import { Controller, Get, Post, Body, Patch, Param, Delete, UseInterceptors, UploadedFiles, Query, ValidationPipe, UsePipes, UseGuards, Req } from '@nestjs/common';
import { PostsService } from './posts.service';
import { CreatePostDto } from './dto/create-post.dto';
import { FilesInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/auth/Decorator/roles.decorator';
import { Role } from 'src/auth/enum/role.enum';
import { RolesGuard } from 'src/auth/guard/roles.guard';
import { QueryPostDto } from './dto/query.dto';


@Controller('posts')
export class PostsController {
  constructor(private readonly postsService: PostsService) {}

  @UseGuards(AuthGuard('jwt'))
  @Get('/pending')
  async findAllpending(@Query() query: QueryPostDto) {
    const posts = await this.postsService.findAllPendings(query);
    return posts
  }


  @UseGuards(AuthGuard('jwt'))
  @Get('/homepage')
  async homePagePost(@Query() query: QueryPostDto, @Req() req){
    return await this.postsService.findhomepagePost(query, req.user['id']);
  }
  @UseGuards(AuthGuard('jwt'))
  @Get('/pending/:id')
  async pendingPost(@Param("id") id: String){
    return await this.postsService.getPending(id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/:id')
  async getPost(@Param("id") id: String){
    return await this.postsService.getApproved(id);
  }

  @Get()
  async findAll(@Query() query: QueryPostDto ) {
    const posts = await this.postsService.findAllAproved(query);
    return posts
  }


  @UseGuards(AuthGuard('jwt'))
  @Post('/pending')
  @UsePipes(new ValidationPipe({ transform: true }))
  createPending(
    @Req() req,
    @Body() createPostDto: CreatePostDto
  ){
    const id = req.user['id']
    return this.postsService.createPending(createPostDto, id);
  }
  
  @UseGuards(AuthGuard('jwt'))
  @Post('pending/images/:id')
  @UseInterceptors(FilesInterceptor('images', 3, {

    storage: diskStorage({
      destination: './images/pending',
      filename(req, file, callback){
        callback(null, `${Date.now()}-${file.originalname}`)
      }
    })
  }))

  creatependingImages(
    @Param('id') id: string,
    @UploadedFiles() files: Array<Express.Multer.File>
  ){

    const images = [];
    files.forEach((file) => {
      images.push(file.filename)
    });
    return this.postsService.insertPendingImages(images, id);
  }
  
  @Post('images/:id')
  @UseInterceptors(FilesInterceptor('files', 3, {

    storage: diskStorage({
      destination: './images/pending',
      filename(req, file, callback){
        callback(null, `${Date.now()}-${file.originalname}`)
      }
    })
  }))
  createImages(
    @Param('id') id: string,
    @UploadedFiles() files: Array<Express.Multer.File>
  ){
    const images = [];
    files.forEach((file) => {
      images.push(file.filename);
    });
    return this.postsService.InsertAprovedimages(images, id);
  }

  @Roles(Role.Admin)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Post('/:id')
  create(
    @Body() createPostDto: CreatePostDto,
    @Param('id') id
  ){
   
    return this.postsService.createAproved(createPostDto,id);
  }
  
  @UseGuards(AuthGuard('jwt'))
  @Patch('like/:postId')
  like(
    @Param('postId') postId ,
    @Req() req
  ){
    const userId=req.user['id']
    return this.postsService.like(postId, userId)
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('unlike/:postId')
  unlike(
    @Param('postId') postId ,
    @Req() req
  ){
    const userId=req.user['id'];
    return this.postsService.unlike(postId, userId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('pending/:id')
  async updatePending(
    @Param('id') postId: string, 
    @Body() updateVal,
    ) {
    const result = await this.postsService.updatePending(postId, updateVal);
    return result
  }

  // @Get('search')
  // searchPost(@Query() serachQuery: string){
  //   return this.postsService.searchAprovedposts(serachQuery);
  // }


  // @Roles(Role.Admin)
  // @UseGuards(AuthGuard('jwt'), RolesGuard)
  // @Patch(':id')
  // async update(
  //   @Param('id') postId: string, 
  //   @Body('story') story: string,
  //   @Body('discription') disc: string,
  //   ) {

  //   const result = await this.postsService.updateAproved(postId, story, disc);
  //   return result
  // }

 

  @UseGuards(AuthGuard('jwt'))
  @Delete('pending/:id')
  async deletePending(@Req() req,@Param('id') id: string){
    const userid=req.user['id']
    return await this.postsService.removePending(id,userid);
  }

  @UseGuards(AuthGuard('jwt'))
  @Delete('/:id')
  async delete(@Req() req, @Param('id') postId){
    const id=req.user['id']
    return await this.postsService.removeAproved(id,postId);
  }

 

  
}