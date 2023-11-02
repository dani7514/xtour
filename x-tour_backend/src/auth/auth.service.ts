import { Injectable, UnauthorizedException } from '@nestjs/common';
import { UserService } from 'src/user/user.service';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { Tokens } from './type/tokens.type';
import { AuthDto } from './AuthDto/auth.dto';
import { User } from 'src/user/userSchema/user.schema';
import { ForbiddenException } from '@nestjs/common';
import { Role } from 'src/auth/enum/role.enum';
import { users } from 'src/user/userDto/user.dto';

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private jwtService: JwtService,
  ) {}

  // async validateUser(username: string, password: string): Promise<any> {
  //   const user = await this.userService.getUser({ username });
  //   const isMatch = await bcrypt.compare(password, user.password);
  //   if (user && isMatch) {
  //     const { password, ...result } = user;
  //     return result;
  //   }
  //   return null;
  // }
  async register(user: users): Promise<User> {
    // const payload={username: user.username ,sub: user.userId};

    return await this.userService.createUser({
      ...user,
      follower: [],
      following: [],
      posts: [],
      penddingPosts: [],
      journals: [],
      pendingJournal: [],
      bookmarkPosts: [],
      profilePicture: '',
      refresh_token: '',
      role: [Role.User],
    });
  }

  async login(users: AuthDto): Promise<any> {
    const username = users.username;
    const password = users.password;
    const user = (await this.userService.getUser( {username})) as any;
    if(!user) throw new UnauthorizedException();
    const isMatch = await bcrypt.compare(password, user.password);
    if (!user || !isMatch) {
      throw new UnauthorizedException();
    }

    const tokens = await this.getTokens(user.id, user.username, user.role);
    await this.userService.updateRtHash(user.id, tokens.refresh_token);

    return tokens;
  }

  async logout(userId: string): Promise<any> {
    const user = (await this.userService.getUser({ userId })) as any;

    await this.userService.updateRtHash(user.id, '');
    return true;
  }

  async refreshTokens(userId: string, rt: string): Promise<Tokens> {
    const user = (await this.userService.getUser({ userId })) as any;

    if (!user || !user.refresh_token) {
      throw new ForbiddenException('Access Denied');
    }

    const isRtMatch = await bcrypt.compare(rt, user.refresh_token);

    if (!isRtMatch) {
      throw new ForbiddenException('Access Denied');
    }

    const tokens = await this.getTokens(user.id, user.username, user.role);
    await this.userService.updateRtHash(user.id, tokens.refresh_token);

    return tokens;
  }

  async getTokens(
    userId: string,
    username: string,
    role: Role[],
  ): Promise<Tokens> {


    const jwtPayload = {
      sub: userId,
      username: username,
    };
    
    const jwtPayloads = {
      sub: userId,
      username: username,
      role: role,
    };

    const [at, rt] = await Promise.all([
      this.jwtService.signAsync(jwtPayloads, {
        secret: 'AT_SECRET',
        expiresIn: '1d',
      }),
      this.jwtService.signAsync(jwtPayload, {
        secret: 'RT_SECRET',
        expiresIn: '7d',
      }),
    ]);

    return {
      access_token: at,
      refresh_token: rt,
    };
  }
}
