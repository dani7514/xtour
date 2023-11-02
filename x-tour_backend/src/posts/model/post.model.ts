import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import * as mongoose from "mongoose";
import { Comments } from "src/comments/Schemas/comments.schema";
import { User } from "src/user/userSchema/user.schema";

// export const postSchema = new mongoose.Schema({
//     story: { type:  String},
//     description: { type: String},
//     comments: { type: [{type: mongoose.Schema.Types.ObjectId, ref:"Comments"}], required: true},
//     likes: { type: [{type: mongoose.Schema.Types.ObjectId, ref:'User'}], required: true},
//     creatorId: { type: mongoose.Schema.Types.ObjectId, ref: "User"},
//     images: { type: Array<String>},
// });

@Schema()
export class Post {
    @Prop()
    story: string

    @Prop()
    description: string

    @Prop( {type: [{type: mongoose.Schema.Types.ObjectId, ref: "Comments"}]})
    comments: mongoose.Schema.Types.ObjectId[]

    @Prop({ type: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }] })
    likes: mongoose.Schema.Types.ObjectId[]

    @Prop({ type: mongoose.Schema.Types.ObjectId, ref: "User" })
    creatorId: mongoose.Schema.Types.ObjectId

    @Prop()
    images: String[]
}

export const postSchema = SchemaFactory.createForClass(Post);
