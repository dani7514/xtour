import { IsNotEmpty, IsString } from "class-validator";
import mongoose from "mongoose";
export class CreateCommentDto {

    replyId:String;

    postId: String;

    @IsNotEmpty()
    @IsString()
    message: String;

}
