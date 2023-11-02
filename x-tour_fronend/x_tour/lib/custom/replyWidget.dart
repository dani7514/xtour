import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/comment/bloc/comment_bloc.dart';
import 'package:x_tour/comment/repository/comment_repository.dart';
import 'package:x_tour/custom/avator_custom.dart';
import 'package:x_tour/user/repository/user_repository.dart';

import '../comment/models/comment.dart';

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  late final CommentBloc commentBloc;
  @override
  void initState() {
    super.initState();
    commentBloc = CommentBloc(
        commentRepository: context.read<CommentRepository>(),
        userRepository: context.read<UserRepository>())
      ..add(GetComments(id: widget.id, isReply: true));
  }

  @override
  void dispose() {
    commentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
        bloc: commentBloc,
        builder: (context, state) {
          if (state is CommentLoading) {
            //TODO
            return CircularProgressIndicator();
          }
          if (state is CommentOperationFailure) {
            //TODO
          }
          if (state is CommentOperationSuccess) {
            final List<Comment> comments = state.comments;
            return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: profile_avatar(
                        radius: 45,
                        imageUrl: comments[index].user!.profilePicture! == ''
                            ? ''
                            : comments[index].user!.profilePicture!,
                        isAsset: comments[index].user!.profilePicture! == '',
                      ),
                      title: Text(comments[index].user!.username!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comments[index].message),
                        ],
                      ),
                      onTap: () {
                        // Handle tapping on a reply
                        // e.g., show options or navigate to user's profile
                      },
                    ),
                  );
                });
          }
          //TODO
          return Text('error');
        });
  }
}
