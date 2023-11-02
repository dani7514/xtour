import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { MongooseModule } from '@nestjs/mongoose';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { User, userSchema } from './userSchema/user.schema';

@Module({
  imports: [MongooseModule.forFeature([{name: User.name , schema: userSchema}]),JwtModule.register({})],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService]
})
export class UserModule {}
