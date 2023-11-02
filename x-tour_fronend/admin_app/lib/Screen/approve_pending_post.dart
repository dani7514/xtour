import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/admin/pending_post/bloc/pending_post_bloc.dart';
import '../admin/pending_post/repository/pending_post_repository.dart';
import '../custom/approve_pendingPost_card.dart'; // Replace 'path_to_post_card' with the actual path to your PostCard widget

class PendingPostListScreen extends StatefulWidget {
  @override
  State<PendingPostListScreen> createState() => _PendingPostListScreenState();
}

class _PendingPostListScreenState extends State<PendingPostListScreen> {
  late final PendingPostBloc pendingPostBloc;

  @override
  void initState() {
    pendingPostBloc = PendingPostBloc(
        pendingPostRepository: context.read<PendingPostRepository>())
      ..add(const LoadPendingPost());
    super.initState();
  }

  @override
  void dispose() {
    pendingPostBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Post List'),
        centerTitle: true,
      ),
      body: BlocBuilder<PendingPostBloc, PendingPostState>(
        bloc: pendingPostBloc,
        builder: (context, state) {
          if (state is PendingPostLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is PendingPostFailure) {
            return Center(
              child: ElevatedButton(
                  onPressed: () {
                    pendingPostBloc.add(const LoadPendingPost());
                  },
                  child: Text("Try Again!")),
            );
          }
          if (state is PendingPostLoaded) {
            final posts = state.posts;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PendingPostCard(
                    post: post, pendingPostBloc: pendingPostBloc);
              },
            );
          }
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  pendingPostBloc.add(const LoadPendingPost());
                },
                child: Text("Try Again!")),
          );
        },
      ),
    );
  }
}
