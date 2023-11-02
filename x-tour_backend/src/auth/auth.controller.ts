import { Body, Delete, Patch, Post, Req, UseGuards, UsePipes, ValidationPipe } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Request } from 'express';
import { users } from 'src/user/userDto/user.dto';
import { User } from 'src/user/userSchema/user.schema';
import { AuthService } from './auth.service';
import { AuthDto } from './AuthDto/auth.dto';
import { Tokens } from './type/tokens.type';

@Controller('auth')
export class AuthController {
    constructor(private authService: AuthService){}

  @Post('/login')
  signin(@Body() dto: AuthDto): Promise<Tokens> {
    return this.authService.login(dto);
  }

  @Post('/signup')
  @UsePipes(new ValidationPipe({transform: true}))
  signUp(@Body() dto: users): Promise<User> {
    return this.authService.register(dto);
  }

  @Patch('/refresh')
  @UseGuards(AuthGuard('jwt-refresh'))
  refresh(@Req() req: Request) {
    const user=req.user;
    return this.authService.refreshTokens(user['id'], user['refreshToken']);
  }

  @UseGuards(AuthGuard('jwt'))
  @Delete('/logout')
  logout(@Req() req: Request) {
    const user=req.user;
    return this.authService.logout(user['id']);
  }

 
}
