import { IsNotEmpty, Length } from "class-validator";
import { Role } from "src/auth/enum/role.enum";

export class users{
    
    fullName: string

    @IsNotEmpty()
    username: string;

    @IsNotEmpty()
    @Length(8,20)
    password: string;

    follower: string[];

    following: string[];

    posts: string[];
    
    penddingPosts: string[];

    bookmarkPosts: string[];

    profilePicture: string;

    refresh_token: string;

    role: Role[];
}