import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:x_tour/posts/bloc/load_posts_bloc.dart' as lpb;
import 'package:x_tour/posts/models/post.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/models/user.dart';
import 'custom.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../comment/screens/commentScreen.dart';

class PostCard extends StatefulWidget {
  PostCard({
    Key? key,
    required this.loadPostsBloc,
    required this.post,
    required this.user,
  }) : super(key: key);

  final lpb.LoadPostsBloc loadPostsBloc;
  final Posts post;
  final User user;

  @override
  PostState createState() => PostState();
}

class PostState extends State<PostCard> {
  final PageController _pageController = PageController();
  late UserBloc userBloc;
  bool isfollow = true;
  bool showAdditionalText = false;
  int? _currentPage = 0;

  late bool liked;
  late bool bookmarked;

  @override
  void initState() {
    super.initState();
    isfollow = widget.user.following!.contains(widget.post.creatorId!.id);
    userBloc = context.read<UserBloc>();
    liked = widget.post.likes!.where((e) => e.id == widget.user.id).isNotEmpty;
    bookmarked = widget.user.bookmarkPosts!.contains(widget.post.id);
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
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            // padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userCard(context),
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
                    photoList(context),
                    DotsIndicator(
                      dotsCount: widget.post.images!.length,
                      position: _currentPage ?? 0,
                      decorator: DotsDecorator(
                        activeColor: Theme.of(context).primaryColor,
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
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Row(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                widget.post.likes!.length <= 3
                                    ? widget.post.likes!.length
                                    : 3,
                                (index) => Row(
                                  children: [
                                    Positioned(
                                      child: profile_avatar(
                                        imageUrl: widget.post.likes![index]
                                                    .profilePicture! ==
                                                ""
                                            ? ""
                                            : widget.post.likes![index]
                                                .profilePicture!,
                                        radius: 30,
                                        isAsset: widget.post.likes![index]
                                                .profilePicture! ==
                                            "",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.post.likes!.isNotEmpty
                            ? 'liked by ${widget.post.likes![0].username} and ${widget.post.likes!.length - 1} others'
                            : "0 likes",
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 7),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showAdditionalText = !showAdditionalText;
                      });
                      // Handle description button press event
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userCard(context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go("/othersProfile/${widget.post.creatorId!.id!}");
      },
      child: Container(
        padding: const EdgeInsets.only(left: 13, right: 13, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                  widget.post.creatorId!.username!,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
            // SizedBox(
            //   width: 180,
            // ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isfollow = !isfollow;
                });
                if (isfollow) {
                  userBloc.add(FollowUser(id: widget.post.creatorId!.id!));
                } else {
                  userBloc.add(UnfollowUser(id: widget.post.creatorId!.id!));
                }
              },
              child: isfollow ? Text('Unfollow') : Text("Follow"),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget photoList(context) {
    final List<String> images = widget.post.images!;
    return Container(
      width: double.infinity,
      height: 350, // Set the height as needed
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              return Stack(children: [
                CachedNetworkImage(
                  imageUrl:
                      "http://10.0.2.2:3000/pending/${widget.post.images![index]}",
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
                //   "http://10.0.2.2:3000/pending/${widget.post.images![index]}",
                //   width: double.infinity,
                //   height: 400, // Adjust the width as needed
                //   fit: BoxFit.cover,
                // ),
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      // begin: Alignment.left,
                      // end: Alignment.bottomCenter,
                      stops: [0.7, 1],
                    ),
                  ),
                ),
              ]);
            },
          ),
          Positioned(
            right: 20,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    liked
                        ? widget.loadPostsBloc
                            .add(lpb.UnlikePost(id: widget.post.id!))
                        : widget.loadPostsBloc
                            .add(lpb.LikePost(id: widget.post.id!));
                    setState(() {
                      liked = !liked;
                    });
                  },
                  child: liked
                      ? iconBuilder(Icons.favorite_rounded)
                      : iconBuilder(Icons.favorite_outline_rounded),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height *
                              0.7, // Set the desired height for the bottom sheet
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: XtourCommentSection(
                            id: widget.post.id!,
                          ),
                        );
                      },
                    );
                  },
                  child: iconBuilder(Icons.comment_outlined),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () => {
                    Share.share(
                        'xtour.com${GoRouter.of(context).location}/${widget.post.id}')
                  },
                  child: iconBuilder(Icons.share),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    bookmarked
                        ? widget.loadPostsBloc
                            .add(lpb.UnbookmarkPost(id: widget.post.id!))
                        : widget.loadPostsBloc
                            .add(lpb.BookmarkPost(id: widget.post.id!));
                    setState(() {
                      bookmarked = !bookmarked;
                    });
                  },
                  child: bookmarked
                      ? iconBuilder(Icons.bookmark_rounded)
                      : iconBuilder(Icons.bookmark_outline_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget iconBuilder(iconData) {
    return Icon(
      iconData,
      size: 30,
    );
  }

  Widget commentBuilder(commentText) {
    return Text(
      commentText,
      style: Theme.of(context).textTheme.bodySmall,
      overflow: TextOverflow.fade,
      maxLines: 1,
    );
  }
}
