import {
  Body,
  Controller,
  Get,
  Post,
  Param,
  Query,
  Patch,
  Delete,
  UsePipes,
  UseInterceptors,
  UploadedFile,
  ValidationPipe,
  UseGuards,
  Req,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express/multer';
import { diskStorage } from 'multer';
import * as path from 'path';
import { CreateJournalDto } from './Dtos/create_journal.dto';
import { QueryStringDto } from './Dtos/query.dto';
import { JournalService } from './journal.service';
import { Journal } from './Schemas/journal.schema';
import { Roles } from 'src/auth/Decorator/roles.decorator';
import { Role } from 'src/auth/enum/role.enum';
import { AuthGuard } from '@nestjs/passport';
import { RolesGuard } from 'src/auth/guard/roles.guard';

@Controller('journals')
export class JournalController {
  constructor(private readonly journalService: JournalService) {}

  @Get()
  async getApprovedJournals(@Query() queryString: QueryStringDto) {
    return await this.journalService.getApprovedJournals(queryString);
  }
  
  @Roles(Role.Journalist, Role.Admin)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Get('/pending')
  async getPendingJournals(@Query() querystring: QueryStringDto) {
    return await this.journalService.getPendingJournals(querystring);
  }

  @Roles(Role.Journalist, Role.Admin)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Get('pending/:id')
  async getPendingJournal(@Param('id') id: string) {
    return await this.journalService.getPendingJournal(id);
  }

  @Get('/:id')
  async getApprovedJournal(@Param('id') id: string) {
    return await this.journalService.getApprovedJournal(id);
  }

  @Roles(Role.Journalist)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Post('/pending')
  @UsePipes(new ValidationPipe({ transform: true }))
  async createJournal(@Req() req, @Body() body: CreateJournalDto) {
    const user = req.user;
    return await this.journalService.createJournal(user['id'], body);
  }
 

  @Roles(Role.Journalist)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Post('pending/image/:id')
  @UseInterceptors(
    FileInterceptor('image', {
      storage: diskStorage({
        destination: './images/pending',
        filename(req, file, callback) {
          callback(
            null,
            Date.now() + path.extname(file.originalname),
          );
        },
      }),
    }),
  )
  async uploadPendingFile(
    @UploadedFile() file: Express.Multer.File,
    @Param('id') id: string,
  ):Promise<Journal> {
    return await this.journalService.insertImageOnPending(id, `${file.filename}`);
  }

  @Post('image/:id')
  @UseInterceptors(
    FileInterceptor('image', {
      storage: diskStorage({
        destination: './images/pending',
        filename(req, file, callback) {
          callback(
            null,
            `${Date.now() + path.extname(file.originalname)}`,
          );
        },
      }),
    }),
  )
  async uploadApprovedFile(
    @UploadedFile() file: Express.Multer.File,
    @Param('id') id: string,
  ) {
    await this.journalService.insertImageOnApproved(id, file.filename);
    const response = {
      originalname: file.originalname,
      filename: file.filename,
    };
    return response;
  }

  @Roles(Role.Admin)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Post('/:id')
  async approveJournal(@Body() body: Journal ,@Param('id') id) {
    return await this.journalService.approveJournal(id, body);
  }

  @Roles(Role.Journalist)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Patch('pending/:id')
  async updatePendingJournal(@Param('id') id: string, @Body() body) {
    return await this.journalService.updatePendingJournal(id, body);
  }

  @Roles(Role.Journalist, Role.Admin)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Patch('/:id')
  async updateApprovedJournal(@Param('id') id: string, @Body() body) {
    return await this.journalService.updateApprovedJournal(id, body);
  }

  @Roles(Role.Journalist, Role.Admin)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Delete('pending/:id')
  async deletePendingJournal(@Param('id') id: string, @Req() req) {
    return this.journalService.deletePendingJournal(id, req.user['id']);
  }

  @Roles(Role.Journalist, Role.Admin)
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Delete('/:id')
  async deleteApprovedJournal(@Param('id') id: string, @Req() req) {
    return this.journalService.deleteApprovedJournal(id, req.user['id']);
  }
}
