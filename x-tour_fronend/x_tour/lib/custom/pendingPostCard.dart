import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x_tour/posts/models/post.dart';
import 'package:x_tour/user/models/user.dart';
import '../custom/custom.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../user/bloc/user_bloc.dart';
import '../user/pending_posts/bloc/pending_posts_bloc.dart';

class PendingPostCard extends StatefulWidget {
  PendingPostCard(
      {Key? key,
      required this.post,
      required this.user,
      required this.userBloc,
      required this.pendingPostsBloc})
      : super(key: key);

  final Posts post;
  final User user;
  final UserBloc userBloc;
  final PendingPostsBloc pendingPostsBloc;

  @override
  PostState createState() => PostState();
}

class PostState extends State<PendingPostCard> {
  final PageController _pageController = PageController();

  bool showAdditionalText = false;
  int? _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.toInt();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userCard(widget.pendingPostsBloc, widget.user, widget.post),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      widget.post.story,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      photoList(widget.post),
                      DotsIndicator(
                        dotsCount: widget.post.images!.length,
                        position: _currentPage ?? 0,
                        decorator: DotsDecorator(
                          activeColor: theme.primaryColor,
                          size: Size.square(8.0),
                          activeSize: Size(20.0, 8.0),
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 7),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showAdditionalText = !showAdditionalText;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              widget.post.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userCard(PendingPostsBloc pendingPostsBloc, User user, Posts post) {
    return Container(
      padding: const EdgeInsets.only(left: 13, top: 10),
      child: Row(
        children: [
          profile_avatar(
            imageUrl: widget.post.creatorId!.profilePicture! == ""
                ? ""
                : "http://10.0.2.2:3000/${widget.post.creatorId!.profilePicture!}",
            radius: 60,
            isAsset: widget.post.creatorId!.profilePicture! == "",
          ),
          const SizedBox(width: 10),
          Text(
            user.username!,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              GoRouter.of(context)
                  .go('/profile/pendingPost/editPendingPost/${post.id}');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDeleteConfirmationDialog(context, pendingPostsBloc, post);
            },
          ),
        ],
      ),
    );
  }

  Widget photoList(Posts post) {
    final List<String> images = post.images!;
    return Container(
      width: double.infinity,
      height: 350,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              return Stack(children: [
                CachedNetworkImage(
                  imageUrl: "http://10.0.2.2:3000/pending/${images[index]}",
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: Theme.of(context).cardColor,
                    child: Icon(
                      Icons.error,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  placeholder: (_, __) => Container(
                    color: Theme.of(context).cardColor,
                  ),
                ),
                // Image.network(
                //   "http://10.0.2.2:3000/pending/${images[index]}",
                //   width: double.infinity,
                //   height: 400,
                //   fit: BoxFit.cover,
                // ),
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(),
                ),
              ]);
            },
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, PendingPostsBloc pendingPostsBloc, Posts post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                pendingPostsBloc.add(DeletePendingPost(id: post.id!));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
