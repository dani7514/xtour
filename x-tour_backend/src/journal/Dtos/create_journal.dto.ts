import { IsNotEmpty } from "class-validator";

export class CreateJournalDto {

  @IsNotEmpty()
  link: string;

  @IsNotEmpty()
  title: string;

  image: string;
  
  @IsNotEmpty()
  description: string;
  
}
