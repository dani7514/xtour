import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import mongoose, { Document } from 'mongoose';
import { Role } from "src/auth/enum/role.enum";
import { Journal } from "src/journal/Schemas/journal.schema";
import { JournalPending } from "src/journal/Schemas/journal_pending.schema";
import { PenddingPost } from "src/posts/model/penndingPost.model";
import { Post } from "src/posts/model/post.model";

export type userDocument= User & Document; 

@Schema()
export class User{
    @Prop()
    fullName: string

    @Prop({unique: true})
    username: string;

    @Prop()
    password: string;

    @Prop({type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User'}] })
    follower: mongoose.Schema.Types.ObjectId[];

    @Prop({type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User'}] })
    following: mongoose.Schema.Types.ObjectId[];

    @Prop({type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Post'}] })
    posts: mongoose.Schema.Types.ObjectId[];

    @Prop({type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Pending'}] })
    penddingPosts: mongoose.Schema.Types.ObjectId[];

    @Prop({type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Journal'}] })
    journals: mongoose.Schema.Types.ObjectId[];

    @Prop({ type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'JournalPending'}] })
    pendingJournal: mongoose.Schema.Types.ObjectId[];

    @Prop({type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Post'}] })
    bookmarkPosts: mongoose.Schema.Types.ObjectId[];

    @Prop()
    profilePicture: string;

    @Prop()
    refresh_token: string;

    @Prop()
    role: Role[];
    
}

export const userSchema=SchemaFactory.createForClass(User);
