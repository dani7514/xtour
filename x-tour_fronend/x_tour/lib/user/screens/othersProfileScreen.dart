import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/custom/custom.dart';
import 'package:x_tour/journal/models/journal.dart';
import '../../journal/repository/journal_repository.dart';
import '../../posts/models/post.dart';
import '../../posts/repository/post_repository.dart';
import '../bloc/user_bloc.dart';
import '../models/user.dart';
import '../other_approved_journal/bloc/other_approved_journal_bloc.dart';
import '../other_approved_posts/bloc/other_approved_posts_bloc.dart';
import '../others_profile/bloc/others_profile_bloc.dart';
import '../repository/user_repository.dart';
import 'othersFollowerScreen.dart';
import 'othersFollowingScreen.dart';

class OtherProfileScreen extends StatefulWidget {
  const OtherProfileScreen({super.key, required this.id});
  final String id;

  @override
  _OtherProfileScreenState createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  late final OthersProfileBloc otherProfileBloc;
  late final OtherApprovedPostsBloc otherApprovedPostsBloc;
  late final OtherApprovedJournalBloc otherApprovedJournalBloc;

  @override
  void initState() {
    super.initState();
    otherProfileBloc =
        OthersProfileBloc(userRepository: context.read<UserRepository>())
          ..add(LoadOtherUser(id: widget.id));
    otherApprovedJournalBloc = OtherApprovedJournalBloc(
        journalRepository: context.read<JournalRepository>(),
        userBloc: context.read<UserBloc>(),
        userRepository: context.read<UserRepository>())
      ..add(GetApprovedJournals(id: widget.id));
    otherApprovedPostsBloc = OtherApprovedPostsBloc(
        userRepository: context.read<UserRepository>(),
        userBloc: context.read<UserBloc>(),
        postRepository: context.read<PostRepository>())
      ..add(LoadPosts(id: widget.id));
  }

  @override
  void dispose() {
    otherProfileBloc.close();
    otherApprovedJournalBloc.close();
    otherApprovedPostsBloc.close();
    super.dispose();
  }

  bool showPost = true;
  bool showPostJournal = false;
  Color postIconColor = Colors.blue;
  Color postJournalIconColor = Colors.grey;

  // final List<Map<String, dynamic>> cardData = [
  //   {
  //     'image': "assets/food_curry.jpg",
  //     'link': 'https://www.youtube.com/',
  //   },
  //   {
  //     'image': "assets/food_cupcake.jpg",
  //     'link': 'https://example.com/card2',
  //   },
  //   {
  //     'image': "assets/food_salmon.jpg",
  //     'link': 'https://example.com/card3',
  //   },
  //   {
  //     'image': "assets/food_curry.jpg",
  //     'link': 'https://example.com/card1',
  //   },
  //   {
  //     'image': "assets/food_cupcake.jpg",
  //     'link': 'https://example.com/card2',
  //   },
  //   {
  //     'image': "assets/food_salmon.jpg",
  //     'link': 'https://example.com/card3',
  //   },
  // ];

  // final List<String> usernames = [
  //   "zele",
  //   "mike",
  //   "leul",
  //   "Abiy",
  //   "Roman",
  //   "Selam",
  // ];
  // final List<String> names = [
  //   "zelalem",
  //   "michael",
  //   "leul",
  //   "abi",
  //   "Romi",
  //   "Seli",
  // ];

  // List<String> postImages = [
  //   "assets/food_brussels_sprouts.jpg",
  //   "assets/food_burger.jpg",
  //   "assets/food_cucumber.jpg",
  //   "assets/food_cupcake.jpg",
  //   "assets/food_curry.jpg",
  //   "assets/food_pho.jpg",
  //   "assets/food_salmon.jpg",
  //   "assets/food_soymilk.png",
  //   "assets/food_spaghetti.jpg",
  //   "assets/person_cesare.jpeg",
  //   "assets/person_crispy.png",
  //   "assets/person_joe.jpeg",
  //   "assets/person_kevin.jpeg",
  //   "assets/person_kelvin.jpg",
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XTourAppBar(
        leading: Image(image: AssetImage('assets/Logo.png')),
        title: "Other profile",
        showActionIcon: Icon(
          Icons.golf_course,
          color: Theme.of(context).cardColor,
        ),
      ),
      body: BlocBuilder<OthersProfileBloc, OthersProfileState>(
        bloc: otherProfileBloc,
        builder: (context, state) {
          if (state is OthersProfileLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OtherProfileOperationFailure) {
            return Center(
              child: ElevatedButton(
                  onPressed: () {
                    otherProfileBloc.add(LoadOtherUser(id: widget.id));
                  },
                  child: Text("Try Again!")),
            );
          }

          if (state is OtherProfileOperationSuccess) {
            final User user = state.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            key: Key("circularAvator"),
                            radius: 30.0,
                            backgroundImage: user.profilePicture != ""
                                ? Image.network(
                                        "http://10.0.2.2:3000/${user.profilePicture!}")
                                    .image
                                : AssetImage(
                                    "assets/person_kelvin.jpg"), // Replace with actual image URL
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        user.username!,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${user.posts!.length}', // Replace with actual post count
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Posts',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    key: Key("followerDialog"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: OthersFollower(
                                      id: user.id!,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  '${user.follower!.length}', // Replace with actual follower count
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    key: Key("followingDialog"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: OthersFollowingScreen(
                                      id: user.id!,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  '${user.following!.length}',
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
                Divider(
                  height: 1.0,
                  color: Colors.grey,
                ),
                SizedBox(
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
                          postIconColor = Colors.blue;
                          postJournalIconColor = Colors.grey;
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
                          showPost = false;
                          showPostJournal = true;
                          postIconColor = Colors.grey;
                          postJournalIconColor = Colors.blue;
                        });
                      },
                      child: Icon(
                        Icons.playlist_add,
                        color: postJournalIconColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: showPost
                        ? postsWidget(
                            otherApprovedPostsBloc: otherApprovedPostsBloc,
                            id: widget.id,
                            postIconColor: postIconColor)
                        : jouranlWidget(
                            otherApprovedJournalsBloc: otherApprovedJournalBloc,
                            id: widget.id,
                            journalIconColor: postJournalIconColor)),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class postsWidget extends StatelessWidget {
  const postsWidget({
    super.key,
    required this.otherApprovedPostsBloc,
    required this.id,
    required this.postIconColor,
  });

  final OtherApprovedPostsBloc otherApprovedPostsBloc;
  final String id;
  final Color postIconColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherApprovedPostsBloc, OtherApprovedPostsState>(
      bloc: otherApprovedPostsBloc,
      builder: (context, state) {
        if (state is PostsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PostsFailed) {
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  otherApprovedPostsBloc.add(LoadPosts(id: id));
                },
                child: Text("Try Again!")),
          );
        }
        if (state is PostsLoaded) {
          final List<Posts> posts = state.posts;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              if (postIconColor == Colors.blue) {
                // Render post images
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.network(
                              "http://10.0.2.2:3000/pending/${posts[index].images![0]}")
                          .image,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}

class jouranlWidget extends StatelessWidget {
  const jouranlWidget({
    super.key,
    required this.otherApprovedJournalsBloc,
    required this.id,
    required this.journalIconColor,
  });

  final OtherApprovedJournalBloc otherApprovedJournalsBloc;
  final String id;
  final Color journalIconColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherApprovedJournalBloc, OtherApprovedJournalState>(
      bloc: otherApprovedJournalsBloc,
      builder: (context, state) {
        if (state is OtherApprovedJournalLoading ||
            state is OtherApprovedPostsInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OtherApprovedJournalOperationFailure) {
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  otherApprovedJournalsBloc.add(GetApprovedJournals(id: id));
                },
                child: Text("Try Again!")),
          );
        }
        if (state is OtherApprovedJournalOperationSuccess) {
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
