import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  Req,
  UploadedFile,
  UseGuards,
  UseInterceptors,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { FileInterceptor } from '@nestjs/platform-express/multer';
import { diskStorage } from 'multer';
import { UserService } from './user.service';
import { Users } from './userDto/update.dto';
import { User } from './userSchema/user.schema';
import { Request } from 'express';
import { Role } from 'src/auth/enum/role.enum';
import { Roles } from 'src/auth/Decorator/roles.decorator';
import { Post as PostModel } from 'src/posts/model/post.model';
import { Journal } from 'src/journal/Schemas/journal.schema';
import { RolesGuard } from 'src/auth/guard/roles.guard';

@Controller('users')
export class UserController {
  constructor(private userService: UserService) {}

  @UseGuards(AuthGuard('jwt'))
  @Get('/info')
  async getUser(@Req() req: Request): Promise<User> {
    const user = req.user;
    const id=user['id'];
    return await this.userService.getUser({_id : id });
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/followers/:id')
  async getOtherFollowers(@Param("id") id: string){
    return this.userService.getUserFollowers(id);
  }
  @UseGuards(AuthGuard('jwt'))
  @Get('/followers')
  async getUserFollowers(@Req() req: Request,@Query() query){
    const user = req.user;
    return this.userService.getUserFollowers(user['id'], );
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/posts/:id')
  async getOtherPosts(@Param("id") id: string){
    return this.userService.getPosts(id);
  }
  
  @UseGuards(AuthGuard('jwt'))
  @Get('/posts')
  async getposts(@Req() req: Request){
    const user = req.user;
    return this.userService.getPosts(user['id']);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/bookmark')
  async getBookmarkposts(@Req() req: Request) {
    const user = req.user;
    return this.userService.getBookmarkPosts(user['id']);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/pendingPosts')
  async getPenndingposts(@Req() req: Request) {
    const user = req.user;
    return this.userService.getPenddingPosts(user['id']);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/journals/:id')
  async getOtherJournal(@Param("id") id: string) {
    return this.userService.getJournals(id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/journals')
  async getjournal(@Req() req: Request) {
    const user = req.user;
    return this.userService.getJournals(user['id']);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/pendingJournals')
  async getPenndingJournals(@Req() req: Request) {
    const user = req.user;
    return this.userService.getPenddingJournal(user['id']);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/followings/:id')
  async getOtherFollowing(@Param("id") id: string) {
    return this.userService.getUserFollowing(id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/followings')
  async getUserFollowing(@Req() req: Request) {
    const user = req.user;
    return this.userService.getUserFollowing(user['id']);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('/:id')
  async getOtherUser(@Param('id') id): Promise<User> {
    return await this.userService.getUser({_id : id });
  }

  @Get()
  async getUsers(): Promise<User[]> {
    return await this.userService.getUsers();
  }

  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Patch('approveJournal/:id')
  async journal(@Param('id') id): Promise<any> {
    return await this.userService.isJournal(id);
  }

  @Roles(Role.Admin)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Patch('approveAdmin')
  async admin(@Req() req: Request): Promise<any> {
    const user = req.user;
    return await this.userService.isAdmin(user['id']);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('follow/:followedUserId')
  async followUser(
    @Req() req: Request,
    @Param('followedUserId') followedUserId: string,
  ) {
    const user = req.user;
    return await this.userService.followUser(user['id'], followedUserId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('unfollow/:unfollowedUserId')
  async unfollowUser(
    @Req() req: Request,
    @Param('unfollowedUserId') unfollowedUserId: string,
  ) {
    const user = req.user;
    return await this.userService.unfollowUser(user['id'], unfollowedUserId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('posts/:postId')
  async storePosts(@Req() req: Request, @Param('postId') postId: string) {
    const user = req.user;
    return await this.userService.posts(user['id'], postId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('penndingPosts/:penddingPostId')
  async storePenndingPosts(@Req() req: Request, @Param('penddingPostId') postId: string) {
    const user = req.user;
    return await this.userService.posts(user['id'], postId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('bookmark/:postId')
  async bookmarkPosts(@Req() req: Request, @Param('postId') postId: string) {
    const user = req.user;
    return await this.userService.bookmarkPosts(user['id'], postId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch('unbookmark/:postId')
  async unbookmarkPosts(@Req() req: Request, @Param('postId') postId: string) {
    const user = req.user;
    return await this.userService.unbookmarkPosts(user['id'], postId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Patch()
  async update(@Req() req: Request, @Body() userDto: Users): Promise<User> {
    const user = req.user;
    return await this.userService.updateUser(user['id'], userDto);
  }

  @UseGuards(AuthGuard('jwt'))
  @Post('/image')
  @UseInterceptors(
    FileInterceptor('image', {
      storage: diskStorage({
        destination: './images/imagess',
        filename: (req, file, cb) => {
          const name = file.originalname.split('.')[0];
          const fileExtention = file.originalname.split('.')[1];
          const newFilename = name + '_' + Date.now() + '.' + fileExtention;

          cb(null, newFilename);
        },
      }),
      fileFilter: (req, file, cb) => {
        if (!file.originalname.match(/\.(jpg|jpeg|png|gif)$/)) {
          return cb(null, false);
        }
        return cb(null, true);
      },
    }),
  )
  async uploadFile(
    @UploadedFile() file: Express.Multer.File,
    @Req() req: Request,
  ): Promise<User> {
    if (!file) {
      throw new BadRequestException('File is not an image');
    } else {
      const response = { profilePicture: `imagess/${file.filename}` };
      const user = req.user;

      return await this.userService.updateUser(user['id'], {
        profilePicture: response.profilePicture,
      }, );
    }
  }

  
}
