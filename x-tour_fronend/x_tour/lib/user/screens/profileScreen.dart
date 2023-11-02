import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_tour/custom/custom.dart';
import 'package:x_tour/screens/screens.dart';
import 'package:x_tour/user/approved_posts/bloc/posts_bloc.dart';
import '../../journal/models/journal.dart';
import '../../journal/repository/journal_repository.dart';
import '../../posts/models/post.dart';
import '../../posts/repository/post_repository.dart';
import '../approved_journal/bloc/journal_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bookmark/bloc/bookmark_bloc.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserBloc userBloc;
  late final ApprovedJournalBloc approvedJournalBloc;
  late final ApprovedPostsBloc approvedPostsBloc;
  late final BookmarkBloc bookmarkBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    approvedJournalBloc = ApprovedJournalBloc(
        userRepository: context.read<UserRepository>(),
        journalRepository: context.read<JournalRepository>(),
        userBloc: userBloc);
    approvedPostsBloc = ApprovedPostsBloc(
        userRepository: context.read<UserRepository>(),
        postRepository: context.read<PostRepository>(),
        userBloc: userBloc);
    bookmarkBloc = BookmarkBloc(
        userRepository: context.read<UserRepository>(), userBloc: userBloc);
  }

  bool showPost = true;
  bool showPendingImages = false;
  bool showPendingJournal = false;
  bool showPostJournal = false;
  bool showBookmark = false;
  Color postIconColor = Colors.blue;
  Color pendingIconColor = Colors.grey;
  Color postJournalIconColor = Colors.grey;
  Color pendingJournalIconColor = Colors.grey;
  Color bookmarkColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is UserOperationSuccess) {
          final User user = (userBloc.state as UserOperationSuccess).user;

          return Scaffold(
            appBar: XTourAppBar(
              leading: Image(image: AssetImage('assets/Logo.png')),
              title: user.username!,
              showActionIcon: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          key: const Key("menuDialog"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(14.0)),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 30),
                                    Text(
                                      user.username!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      user.fullName!,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.pending),
                                        title: Text('Pending Post'),
                                        onTap: () {
                                          GoRouter.of(context)
                                              .go('/profile/pendingPost');
                                          GoRouter.of(context).pop(
                                              context); // Dismiss the dialog
                                        },
                                      ),
                                    ),
                                    user.role!.contains("journalist")
                                        ? PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.lock_clock),
                                              title: Text('Pending Journal'),
                                              onTap: () {
                                                GoRouter.of(context).go(
                                                    '/profile/pendingJournal');
                                                GoRouter.of(context).pop(
                                                    context); // Dismiss the dialog
                                              },
                                            ),
                                          )
                                        : Container(),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.person),
                                        title: Text('Edit Profile'),
                                        onTap: () {
                                          GoRouter.of(context)
                                              .go('/profile/editProfile');
                                          GoRouter.of(context).pop(
                                              context); // Dismiss the dialog
                                        },
                                      ),
                                    ),
                                    user.follower!.length > 4 &&
                                            !user.role!.contains("journalist")
                                        ? PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.man),
                                              title: Text('Become a journal'),
                                              onTap: () {
                                                context
                                                    .read<UserRepository>()
                                                    .requestJournal(user.id!);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Container(
                                                    child: Text(
                                                      "Your request is sent",
                                                    ),
                                                  ),
                                                ));
                                              },
                                            ),
                                          )
                                        : Container(),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.logout),
                                        title: Text('Logout'),
                                        onTap: () {
                                          context
                                              .read<AuthBloc>()
                                              .add(LogOut());
                                          GoRouter.of(context).pop(
                                              context); // Dismiss the dialog
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -35,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromARGB(255, 14, 201, 55),
                                      width: 3,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage: user.profilePicture != ""
                                        ? Image.network(
                                                "http://10.0.2.2/${user.profilePicture!}")
                                            .image
                                        : AssetImage(
                                            "assets/person_kelvin.jpg"),
                                    // TODO
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.username!,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            key: const Key("followerGesture"),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    key: const Key("followerDialog"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const FollowerScreen(),
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  '${user.follower!.length}', // Replace with actual follower count
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                const Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .primaryColor, // Replace with your desired border color
                                    width: 4, // Adjust the width of the border
                                  ),
                                ),
                                child: CircleAvatar(
                                  key: const Key("avatorAtTheCenter"),
                                  radius: 40.0,
                                  backgroundImage: user.profilePicture != ""
                                      ? Image.network(
                                              "http://10.0.2.2:3000/${user.profilePicture!}")
                                          .image
                                      : const AssetImage(
                                          "assets/person_kelvin.jpg"), // Replace with actual image URL
                                ),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                          GestureDetector(
                            key: const Key("followingGesture"),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    key: const Key("followingDialog"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const FollowingScreen(),
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  '${user.following!.length}', // Replace with actual following count
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                const Divider(
                  height: 1.0,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showPost = true;
                          showPostJournal = false;
                          showBookmark = false;
                          postIconColor = Colors.blue;
                          postJournalIconColor = Colors.grey;
                          bookmarkColor = Colors.grey;
                        });
                      },
                      child: Icon(
                        Icons.photo_library,
                        color: postIconColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showBookmark = false;
                          showPost = false;
                          showPostJournal = true;
                          postIconColor = Colors.grey;
                          postJournalIconColor = Colors.blue;
                          bookmarkColor = Colors.grey;
                        });
                      },
                      child: Icon(
                        Icons.article_outlined,
                        color: postJournalIconColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showBookmark = true;
                          showPost = false;
                          showPostJournal = false;
                          postIconColor = Colors.grey;
                          postJournalIconColor = Colors.grey;
                          bookmarkColor = Colors.blue;
                        });
                      },
                      child: Icon(
                        Icons.bookmark_add,
                        color: bookmarkColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: showPost
                        ? postsWidget(
                            aprovedPostsBloc: approvedPostsBloc,
                            postIconColor: postIconColor)
                        : showPostJournal
                            ? jouranlWidget(
                                approvedJournalsBloc: approvedJournalBloc,
                                journalIconColor: postJournalIconColor)
                            : bookmarkWidget(
                                bookmarkBloc: bookmarkBloc,
                              )),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

class postsWidget extends StatelessWidget {
  postsWidget({
    super.key,
    required this.aprovedPostsBloc,
    required this.postIconColor,
  }) {
    aprovedPostsBloc.add(const GetApprovedPost());
  }

  final ApprovedPostsBloc aprovedPostsBloc;
  final Color postIconColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovedPostsBloc, ApprovedPostsState>(
      bloc: aprovedPostsBloc,
      builder: (context, state) {
        if (state is ApprovedPostsLoading || state is ApprovedPostsInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ApprovedPostsOperationFailure) {
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  aprovedPostsBloc.add(const GetApprovedPost());
                },
                child: Text("Try Again!")),
          );
        }
        if (state is ApprovedPostsOperationSuccess) {
          final List<Posts> posts = state.posts;
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    GoRouter.of(context)
                        .go('/profile/postDetail/${posts[index].id}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: Image.network(
                                "http://10.0.2.2:3000/pending/${posts[index].images![0]}")
                            .image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              });
        }
        return Container(
          child: Text("$state"),
        );
      },
    );
  }
}

class jouranlWidget extends StatelessWidget {
  jouranlWidget({
    super.key,
    required this.approvedJournalsBloc,
    required this.journalIconColor,
  }) {
    approvedJournalsBloc.add(const GetApprovedJournals());
  }

  final ApprovedJournalBloc approvedJournalsBloc;
  final Color journalIconColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovedJournalBloc, ApprovedJournalState>(
      bloc: approvedJournalsBloc,
      builder: (context, state) {
        if (state is ApprovedJournalLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ApprovedJournalOperationFailure) {
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  approvedJournalsBloc.add(const GetApprovedJournals());
                },
                child: Text("Try Again!")),
          );
        }
        if (state is ApprovedJournalOperationSuccess) {
          final List<Journal> journals = state.journals;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: journals.length,
            itemBuilder: (BuildContext context, int index) {
              final data = journals[index];
              return _buildCard(
                image: data.image!,
                link: data.link,
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

class bookmarkWidget extends StatelessWidget {
  bookmarkWidget({
    super.key,
    required this.bookmarkBloc,
  }) {
    bookmarkBloc.add(LoadBookmarkPosts());
  }

  final BookmarkBloc bookmarkBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      bloc: bookmarkBloc,
      builder: (context, state) {
        if (state is BookmarkLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is BookmarkOperationFailure) {
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  bookmarkBloc.add(LoadBookmarkPosts());
                },
                child: Text("Try Again!")),
          );
        }
        if (state is BookmarkOperationSuccess) {
          final List<Posts> posts = state.bookmarkPosts;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final data = posts[index];
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.network(
                            "http://10.0.2.2:3000/pending/${data.images![0]}")
                        .image,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

Widget _buildCard({required String image, required String link}) {
  return Card(
    child: InkWell(
      onTap: () {},
      child: Column(
        children: [
          Image.network(
            "http://10.0.2.2:3000/pending/$image",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Here is a link',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
