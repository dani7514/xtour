import { Schema, Prop, SchemaFactory } from '@nestjs/mongoose';
import mongoose from 'mongoose';
import { User } from 'src/user/userSchema/user.schema';

@Schema()
export class Journal {
  @Prop({ type: mongoose.Schema.Types.ObjectId, ref: 'User' })
  creator_id: User;

  @Prop()
  title: string;

  @Prop()
  link: string;

  @Prop()
  image: string;

  @Prop()
  description: string;
  
}

export const JournalSchema = SchemaFactory.createForClass(Journal);
