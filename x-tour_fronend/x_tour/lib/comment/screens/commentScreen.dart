import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_tour/comment/bloc/comment_bloc.dart';
import 'package:x_tour/comment/repository/comment_repository.dart';
import '../models/comment.dart';
import '../../custom/custom.dart';
import '../../custom/replyWidget.dart';
import '../../user/repository/user_repository.dart';

class XtourCommentSection extends StatefulWidget {
  const XtourCommentSection({super.key, required this.id});
  final String id;

  @override
  _XtourCommentSectionState createState() => _XtourCommentSectionState();
}

class _XtourCommentSectionState extends State<XtourCommentSection> {
  late CommentBloc commentBloc;
  bool isreply = false;

  @override
  void initState() {
    super.initState();
    commentBloc = CommentBloc(
        commentRepository: context.read<CommentRepository>(),
        userRepository: context.read<UserRepository>())
      ..add(GetComments(id: widget.id));
  }

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    commentBloc.close();
    _commentController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          SizedBox(
            height: 6,
          ),
          Text(
            'Comments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: BlocConsumer<CommentBloc, CommentState>(
                listener: (context, state) {
                  if (state is CommentCreationOperationFailure) {
                    final snackBar =
                        SnackBar(content: Text("Comment not sent"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                bloc: commentBloc,
                builder: (context, state) {
                  if (state is CommentLoading) {
                    //TODO:
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is CommentOperationFailure) {
                    return ElevatedButton(
                        onPressed: () {
                          commentBloc.add(GetComments(id: widget.id));
                        },
                        child: Text("Try Again!"));
                  }

                  if (state is CommentOperationSuccess) {
                    final List<Comment> comments = state.comments;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];

                        return Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            ListTile(
                              leading: profile_avatar(
                                radius: 45,
                                imageUrl: comment.user!.profilePicture! == ''
                                    ? ''
                                    : comment.user!.profilePicture!,
                                isAsset: comment.user!.profilePicture! == '',
                              ),
                              title: Text(comment.user!.username!),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comment.message),
                                  SizedBox(height: 4),
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Replying to ${comment.user!.username}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              controller:
                                                                  _replyController,
                                                              autofocus: true,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    'Enter your reply',
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                                Icons.send),
                                                            onPressed: () {
                                                              final reply =
                                                                  _replyController
                                                                      .text;
                                                              if (reply
                                                                  .isNotEmpty) {
                                                                commentBloc.add(CreateComment(
                                                                    comment: Comment(
                                                                        message:
                                                                            reply,
                                                                        replyId:
                                                                            comment.id)));
                                                                GoRouter.of(
                                                                        context)
                                                                    .pop();
                                                                _replyController
                                                                    .clear();
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Reply'),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Handle tapping on a comment
                                // e.g., show options or navigate to user's profile
                              },
                            ),
                            isreply
                                ? ReplyWidget(id: comment.id!)
                                : Container(),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isreply = !isreply;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    isreply ? 'View replies' : 'Hide replies',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    );
                  }
                  //TODO
                  return Text('Error');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      final comment = _commentController.text;
                      if (comment.isNotEmpty) {
                        commentBloc.add(CreateComment(
                            comment:
                                Comment(message: comment, postId: widget.id)));
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
