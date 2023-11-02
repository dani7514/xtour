import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { FilterQuery, Model } from 'mongoose';
import { User, userDocument } from './userSchema/user.schema';
import * as bcrypt from 'bcrypt';
import { Role } from "src/auth/enum/role.enum";
import { Post } from 'src/posts/model/post.model';
import { Journal } from 'src/journal/Schemas/journal.schema';

@Injectable()
export class UserService {
    userId: string;
    constructor(@InjectModel(User.name) private userModel: Model<userDocument>){}

    async getUser(filterQuery: FilterQuery<User>): Promise<User>{
        return await this.userModel.findOne(filterQuery);
    }

    async getUsers(): Promise<User[]>{
        return await this.userModel.find()
    }

    async createUser(user: User): Promise<User>{
        const salt = await bcrypt.genSalt();
        const hashPassword = await bcrypt.hash(user.password, salt);
        user.password=hashPassword
        const users= new this.userModel(user);
        return  await users.save()
    }

    async updateUser(filterQuery: FilterQuery<User>, user: Partial<User>): Promise<User>{
        return this.userModel.findByIdAndUpdate(filterQuery,user, {returnOriginal: false})
    }

    async followUser(userId: string, followedUserId: string) {
        await this.userModel.findByIdAndUpdate(followedUserId, { $addToSet : { follower: userId } });
        return await this.userModel.findByIdAndUpdate(userId , {  $addToSet : { following: followedUserId } },{returnOriginal: false}); 
    }
    
    async unfollowUser(userId: string, unfollowedUserId: string) {
        await this.userModel.findByIdAndUpdate(unfollowedUserId , { $pull: { follower: userId } });
        return await this.userModel.findByIdAndUpdate(userId , { $pull: { following: unfollowedUserId } },{returnOriginal: false});
    }

    async getUserFollowers(userId: string) {
        const user = await this.userModel.findById(userId).populate('follower').select('follower').exec();
        return user.follower;
    }

    async getUserFollowing(userId: string) {
        const user = await this.userModel.findById(userId).populate('following').select('following').exec();
        return user.following;
    }

    async posts(userId: string, postId: string){
        return await this.userModel.findByIdAndUpdate(userId,{ $addToSet : {posts: postId}});
    }

    async removePosts(userId: string, postId: string){
        await this.userModel.findByIdAndUpdate(userId,{ $pull : {posts: postId}});
    }

    async getPosts(id: string) {
        const user = await this.userModel.findById(id).populate({path: 'posts', populate: [
            { path: 'comments', populate: { path: 'commenterId', model: "User" }},
            'creatorId',
            'likes',
          ]}).select('posts').exec();
        return user.posts;
    }

    async penddingposts(userId: string, postId: string){
        return await this.userModel.findByIdAndUpdate(userId, { $addToSet : {penddingPosts: postId}},{returnOriginal: false});
    }

    async getPenddingPosts(id: string) {
        const user = await this.userModel.findById(id);
        await user.populate({ path: 'penddingPosts' , populate: {
            path: "creatorId",
            model: "User",
        }});
        console.log(user);
        return user.penddingPosts;
    }


    async removePenddingposts(userId: string, postId: string){
        await this.userModel.findByIdAndUpdate(userId, { $pull : {penddingPosts: postId}});
    }

    async journals(userId, journalId: string){
        return await this.userModel.findByIdAndUpdate(userId,{ $addToSet : {journals: journalId}},{returnOriginal: false});
    }

    async removeJournals(userId: string, journalId: string){
        await this.userModel.findByIdAndUpdate(userId,{ $pull : {journals: journalId}});
    }

    async getJournals(id: string) {
        const user = await this.userModel.findById(id).populate('journals').select('journals').exec();
        return user.journals;
    }

    async penddingJournal(userId: string, journalId: string){
        return await this.userModel.findByIdAndUpdate(userId, { $addToSet : {pendingJournal: journalId}},{returnOriginal: false});
    }

    async getPenddingJournal(id: string) {
        const user = await this.userModel.findById(id).populate({path: 'pendingJournal', populate: {
            path: "creator_id",
            model: "User",
        }}).select('pendingJournal').exec();
        return user.pendingJournal;
    }


    async removePenddingJournal(userId, journalId: string){
        await this.userModel.findByIdAndUpdate(userId, { $pull : {pendingJournal: journalId}});
    }

    async bookmarkPosts(userId: string, postId: string){
        return await this.userModel.findByIdAndUpdate(userId, { $addToSet : {posts: postId}},{returnOriginal: false});
    }

    async unbookmarkPosts(userId: string, postId: string){
        return await this.userModel.findByIdAndUpdate(userId, { $pull : {posts: postId}},{returnOriginal: false});
    }
    
    async getBookmarkPosts(id: string) {
        const user = await this.userModel.findById(id).populate('bookmarkPosts').select('bookmarkPosts').exec();
        return user.bookmarkPosts;
    }

    async updateRtHash(userId: string, rt: string): Promise<void> {
        const salt = await bcrypt.genSalt();
        const hashRt = await bcrypt.hash(rt, salt);
        await this.userModel.findByIdAndUpdate(userId,{refresh_token: hashRt});
    }

    async isJournal(userId: string): Promise<any>{
        return await this.userModel.findByIdAndUpdate(userId, { $addToSet : {role: Role.Journalist}})
       
    }

    async isAdmin(userId: string): Promise<any>{
        await this.userModel.findByIdAndUpdate(userId, { $addToSet : {role: Role.Admin}})
       
    }


  
} 
