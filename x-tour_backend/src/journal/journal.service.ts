import { DynamicModule, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose/dist';
import { Model } from 'mongoose';
import { CreateJournalDto } from './Dtos/create_journal.dto';
import { QueryStringDto } from './Dtos/query.dto';
import { Journal } from './Schemas/journal.schema';
import { JournalPending } from './Schemas/journal_pending.schema';
import { UserService } from 'src/user/user.service';

@Injectable()
export class JournalService {
  constructor(
    @InjectModel(Journal.name) private readonly journalModel: Model<Journal>,
    @InjectModel(JournalPending.name)
    private readonly journalPendingModel: Model<JournalPending>,
    private readonly userService: UserService,
  ) {}

  async insertImage(model: any, id: string, image_url: string) {
    return await model.findByIdAndUpdate(
      id,
      { image: image_url },
      { returnOriginal: false },
    ).populate("creator_id");
  }

  async getJournal(model: any, id: string) {
    return await model.findById(id).populate("creator_id");
  }

  async getJournals(model, queryString: QueryStringDto) {
    const { search = '', perPage = 20, page = 1 } = queryString;
    const skip = perPage * (page - 1);
    const journals = await model
      .find({ title: { $regex: search, $options: 'i' } })
      .limit(perPage)
      .skip(skip)
      .populate("creator_id");
    const journalsCount = await model.count({
      title: { $regex: search, $options: 'i' },
    });

    return journals;
  }

  async updateJournal(model: any, id: string, journal) {
    return await model.findByIdAndUpdate(id, journal, {
      returnOriginal: false,
    }).populate("creator_id");
  }

  async deleteJournal(model, id: string) {
    return await model.findByIdAndDelete(id);
  }

  // Operations on Pending Journals

  async createJournal(creator_id : string, journal: CreateJournalDto) {
    const newJournal = await this.journalPendingModel.create({ ...journal, creator_id, image: '' });
    await this.userService.penddingJournal(creator_id, newJournal.id);
    return newJournal.populate("creator_id");
  }
  async insertImageOnPending(id: string, image_url: string) {
    return await this.insertImage(this.journalPendingModel, id, image_url);
  }
  async getPendingJournal(id: string) {
    return await this.getJournal(this.journalPendingModel, id);
  }

  async getPendingJournals(queryString: QueryStringDto) {
    return await this.getJournals(this.journalPendingModel, queryString);
  }
  async updatePendingJournal(id: string, journal) {
    return await this.updateJournal(this.journalPendingModel, id, journal);
  }

  async deletePendingJournal(id: string, userId: string) {
    await this.userService.removePenddingJournal(userId, id);
    return await this.deleteJournal(this.journalPendingModel, id);
  }

  // Operations on Approved Journals

  async approveJournal(id: string, journal: Journal) {
    await this.journalPendingModel.findByIdAndDelete(id);
    await this.userService.removePenddingJournal(journal.creator_id, id);
    const newJournal = await this.journalModel.create(journal);
    await this.userService.journals(journal.creator_id, newJournal.id);
    return newJournal;
  }

  async getApprovedJournal(id: string) {
    return await this.getJournal(this.journalModel, id);
  }

  async getApprovedJournals(queryString: QueryStringDto) {
    return await this.getJournals(this.journalModel, queryString);
  }

  async insertImageOnApproved(id: string, image_url: string) {
    return await this.insertImage(this.journalModel, id, image_url);
  }

  async updateApprovedJournal(id: string, journal) {
    return await this.updateJournal(this.journalModel, id, journal);
  }

  async deleteApprovedJournal(id: string, userId: string) {
    await this.userService.removeJournals(userId, id);
    return await this.deleteJournal(this.journalModel, id);
  }
}
