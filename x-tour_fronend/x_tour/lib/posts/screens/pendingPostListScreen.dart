import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/custom/custom.dart';
import 'package:x_tour/user/pending_posts/bloc/pending_posts_bloc.dart';
import '../../custom/pendingPostCard.dart';
import '../../user/bloc/user_bloc.dart';
import '../models/post.dart';

class PendingPostListScreen extends StatefulWidget {
  @override
  State<PendingPostListScreen> createState() => _PendingPostListScreenState();
}

class _PendingPostListScreenState extends State<PendingPostListScreen> {
  late PendingPostsBloc pendingPostsBloc;
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    pendingPostsBloc = context.read<PendingPostsBloc>()
      ..add(const GetPendingPost());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingPostsBloc, PendingPostsState>(
      bloc: pendingPostsBloc,
      builder: (context, state) {
        if (state is PendingPostsLoading || state is PendingPostsInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PendingPostsOperationSuccess) {
          final List<Posts> posts = state.posts;
          return Scaffold(
            appBar: const XTourAppBar(
              title: 'Pending Post List',
            ),
            body: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return BlocProvider<PendingPostsBloc>.value(
                  value: pendingPostsBloc,
                  child: PendingPostCard(
                    pendingPostsBloc: pendingPostsBloc,
                    post: posts[index],
                    user: (userBloc.state as UserOperationSuccess).user,
                    userBloc: userBloc,
                  ),
                );
              },
            ),
          );
        }
        return Container(
          child: Text("dfef"),
        ); // TODO
      },
    );
  }
}
