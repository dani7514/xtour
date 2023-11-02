import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/custom/custom.dart';
import 'package:x_tour/posts/bloc/load_posts_bloc.dart';
import 'package:x_tour/posts/repository/post_repository.dart';
import 'package:x_tour/screens/error_page.dart';
import 'package:x_tour/screens/splash_page.dart';
import '../../custom/postCard.dart';
import '../../user/bloc/user_bloc.dart';

class PostListScreen extends StatefulWidget {
  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late LoadPostsBloc loadPostsBloc;
  int currentPage = 1;

  @override
  void initState() {
    loadPostsBloc = LoadPostsBloc(
        postRepository: context.read<PostRepository>(),
        userBloc: context.read<UserBloc>())
      ..add(const LoadPosts());

    super.initState();
  }

  @override
  void dispose() {
    loadPostsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XTourAppBar(
        leading: Image(image: AssetImage('assets/Logo.png')),
        title: "Posts",
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserOperationSuccess) {
            return BlocBuilder<LoadPostsBloc, LoadPostsState>(
                bloc: loadPostsBloc,
                builder: (context, state) {
                  if (state is PostsLoading || state is LoadPostsInitial) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is PostsFailed) {
                    return ElevatedButton(
                        onPressed: () {
                          loadPostsBloc.add(const LoadPosts());
                        },
                        child: Text("Try Again!"));
                  }
                  if (state is PostsLoaded) {
                    final posts = state.posts;
                    final user =
                        (context.read<UserBloc>().state as UserOperationSuccess)
                            .user;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(
                          post: post,
                          user: user,
                          loadPostsBloc: loadPostsBloc,
                        );
                      },
                    );
                  }
                  return ErrorPage();
                });
          }
          return SplashPage();
        },
      ),
    );
  }
}
