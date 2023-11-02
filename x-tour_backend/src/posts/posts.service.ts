import { HttpException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreatePostDto } from './dto/create-post.dto';
import { Post } from './model/post.model';
import { PenddingPost } from './model/penndingPost.model';
import { UserService } from 'src/user/user.service';
import { QueryPostDto } from './dto/query.dto';
import { PassportModule } from '@nestjs/passport';
import { User } from 'src/user/userSchema/user.schema';
import { Comments } from 'src/comments/Schemas/comments.schema';

@Injectable()
export class PostsService {
  constructor(
    @InjectModel('Post') private readonly postModel: Model<Post>,
    @InjectModel('Pending')
    private readonly PendingpostModel: Model<PenddingPost>,
    private readonly userService: UserService,
  ) {}

  async insertImages(Model: any, images: Array<any>, id: string) {
    const createdPost = await Model.findByIdAndUpdate(
      { _id: id },
      { images: images },
    ).populate([
      { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      'creatorId',
      'likes',
    ]);
    return createdPost;
  }

  async findAll(Model: any) {
    const posts = await Model.find().populate([
      { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      'creatorId',
      'likes',
    ]);
    return posts as Post[];
  }

  async searchPost(Model: any, searchParam: string) {
    const posts = await Model.find({ story: searchParam }).populate([
      { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      'creatorId',
      'likes',
    ]);
    return posts as Post[];
  }

  async findhomepagePost(query, id: string) {
    const { search = '', perPage = 20, page = 1 } = query;
    const skip = perPage * (page - 1);

    const followings = (await this.userService.getUser({ _id: id })).following;
    console.log(followings);
    const posts = await this.postModel
      .find({
        creatorId: { $in: followings },
        story: { $regex: search, $options: 'i' },
      })
      .populate([
        'creatorId',
        'likes',
        { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      ]);
    const posts2 = await this.postModel
      .find({
        creatorId: { $nin: followings },
      })
      .populate([
        'creatorId',
        'likes',
        { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      ]);
    console.log(posts.concat(posts2));
    return posts.concat(posts2);
  }

  async like(postId: string, userId: string) {
    return await this.postModel
      .findByIdAndUpdate(
        postId,
        { $addToSet: { likes: userId } },
        { returnOriginal: false },
      )
      .populate([
        { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
        'creatorId',
        'likes',
      ]);
  }

  async unlike(postId: string, userId: string) {
    return await this.postModel
      .findByIdAndUpdate(
        postId,
        { $pull: { likes: userId } },
        { returnOriginal: false },
      )
      .populate([
        { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
        'creatorId',
        'likes',
      ]);
  }

  async update(Model: any, id: string, updateVal) {
    const updatedproduct = await Model.findByIdAndUpdate(
      id,
      updateVal,
    ).populate([
      { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      'creatorId',
      'likes',
    ]);
    return updatedproduct;
  }

  async remove(model: any, id: string, userid: string, pending = false) {
    if (pending) {
      await this.userService.removePenddingposts(userid, id);
    } else {
      await this.userService.removePosts(userid, id);
    }
    return await model.deleteOne({ _id: id }).exec();
  }

  //----------------------------------------------------------------
  /// operations for the Aproved Posts
  async getApproved(id: String): Promise<Post> {
    return await this.postModel
      .findById(id)
      .populate([
        { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
        'creatorId',
        'likes',
      ]);
  }
  async createAproved(createPost, id: string): Promise<Post> {
    await this.PendingpostModel.findByIdAndDelete(id);
    await this.userService.removePenddingposts(createPost.creatorId, id);
    const newpost = await this.postModel.create(createPost);
    await this.userService.posts(createPost.creatorId, newpost.id);
    return newpost;
  }

  async comments(commenteId: string, postId) {
    await this.postModel
      .findByIdAndUpdate(postId, { $addToSet: { comments: commenteId } })
      .populate([
        { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
        'creatorId',
        'likes',
      ]);
  }

  async InsertAprovedimages(images: Array<any>, id: string) {
    return await this.insertImages(this.postModel, images, id);
  }

  async findAllAproved(query: QueryPostDto) {
    const { search = '', perPage = 20, page = 1 } = query;
    const skip = perPage * (page - 1);
    const posts = await this.postModel
      .find({ story: { $regex: search, $options: 'i' } })
      .limit(perPage)
      .skip(skip)
      .populate([
        { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
        'creatorId',
        'likes',
      ]);

    // const postsCount = await this.postModel.count({
    //   title: { $regex: search, $options: 'i' },
    // });
    return posts;
  }
  async searchAprovedposts(searchTerm: string) {
    return await this.searchPost(this.postModel, searchTerm);
  }

  // async updateAproved(id: string, story: string, description: string) {
  //   return await this.update(this.postModel, id, story, description);
  // }

  async removeAproved(id: string, postId: string) {
    return await this.remove(this.postModel, id, postId);
  }

  //================================================
  // operations for the pennding collection

  async createPending(
    createPost: CreatePostDto,
    id: string,
  ): Promise<PenddingPost> {
    const newPost = await this.PendingpostModel.create({
      ...createPost,
      creatorId: id,
      images: [],
    });

    await newPost.populate([
      { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      'creatorId',
      'likes',
    ]);
    await this.userService.penddingposts(id, newPost.id);
    return newPost;
  }
  async getPending(id: String): Promise<Post> {
    console.log(id);
    return await this.PendingpostModel.findById(id).populate([
      { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      'creatorId',
      'likes',
    ]);
  }
  async findAllPendings(query: QueryPostDto) {
    const pendingPosts = await this.PendingpostModel.find().populate([
      { path: 'comments', populate: { path: 'commenterId', model: 'User' } },
      'creatorId',
      'likes',
    ]);
    return pendingPosts;
  }

  async updatePending(id: string, updateVal) {
    return await this.update(this.PendingpostModel, id, updateVal);
  }

  async removePending(id: string, userid: string) {
    return await this.remove(this.PendingpostModel, id, userid, true);
  }

  async insertPendingImages(images: Array<any>, id) {
    return await this.insertImages(this.PendingpostModel, images, id);
  }
}
