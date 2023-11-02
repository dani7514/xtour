import { Schema, SchemaFactory } from '@nestjs/mongoose';
import { Journal } from './journal.schema';

@Schema()
export class JournalPending extends Journal {}

export const JournalPendingSchema =
  SchemaFactory.createForClass(JournalPending);
