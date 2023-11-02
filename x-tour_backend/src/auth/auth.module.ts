import { Module } from '@nestjs/common';
import { UserModule } from 'src/user/user.module';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { AtStrategy } from './strategies/at.strategy';
import { RtStrategy } from './strategies/rt.strategy';
@Module({
  imports:[UserModule, PassportModule,JwtModule.register({}),],
  controllers: [AuthController],
  providers: [AuthService, 
    AtStrategy, 
    RtStrategy,
  ]
})
export class AuthModule {}
