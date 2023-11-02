import { IsNotEmpty, Length } from "class-validator";
import { Role } from "src/auth/enum/role.enum";

export class Users{
    password: string;
    profilePicture: string;
    username: string;
}
