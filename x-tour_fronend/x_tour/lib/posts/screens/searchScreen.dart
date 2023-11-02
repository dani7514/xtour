import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_tour/posts/models/post.dart';
import 'package:x_tour/posts/repository/post_repository.dart';
import 'package:x_tour/posts/search_post/bloc/searchpost_bloc.dart';
import '../../custom/xtour_appBar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchpostBloc searchpostBloc;

  TextEditingController _searchController = TextEditingController();
  bool isTop = true;
  bool isPost = false;
  bool isAccount = false;
  bool isJournal = false;
  List postImages = [
    "assets/person_cesare.jpeg",
    "assets/person_crispy.png",
    "assets/person_joe.jpeg",
    "assets/person_kevin.jpeg",
    "assets/person_kelvin.jpg",
    "assets/person_katz.jpeg"
  ];

  @override
  void initState() {
    super.initState();
    searchpostBloc =
        SearchpostBloc(postRepository: context.read<PostRepository>())
          ..add(const SearchPost());
  }

  @override
  void dispose() {
    searchpostBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XTourAppBar(
        leading: Image(image: AssetImage('assets/Logo.png')),
        title: "",
        showActionIcon: Text(""),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  onChanged: (value) {
                    searchpostBloc
                        .add(SearchPost(search: _searchController.text));
                  },
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearSearchQuery,
                  ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Expanded(
            child: BlocBuilder<SearchpostBloc, SearchpostState>(
              bloc: searchpostBloc,
              builder: (context, state) {
                if (state is SearchpostLoading) {
                  //TODO
                  return Center(child: CircularProgressIndicator());
                }
                if (state is SearchpostFailed) {
                  //TODO
                  return Center(child: Text('Try Again'));
                }
                if (state is SearchpostLoaded) {
                  final List<Posts> posts = state.posts;

                  if (posts.isEmpty) {
                    return Center(
                      child: Text("No Search Found"),
                    );
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final imagePath = posts[index].images![0];

                      return GestureDetector(
                        onTap: () {
                          //TODO
                          GoRouter.of(context).go("${posts[index].id!}");
                        },
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context)
                                .go('/search/postDetail/${posts[index].id!}');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Image.network(
                                        "http://10.0.2.2:3000/pending/$imagePath")
                                    .image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                //TODO
                return Center(child: Text('Error'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
