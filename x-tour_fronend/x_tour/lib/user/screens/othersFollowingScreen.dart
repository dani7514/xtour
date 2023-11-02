import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/screens/error_page.dart';

import '../../custom/avator_custom.dart';
import '../bloc/user_bloc.dart';
import '../models/user.dart';
import '../others_following/bloc/other_followings_bloc.dart';
import '../repository/user_repository.dart';

class OthersFollowingScreen extends StatefulWidget {
  const OthersFollowingScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<OthersFollowingScreen> createState() => _OthersFollowingScreenState();
}

class _OthersFollowingScreenState extends State<OthersFollowingScreen> {
  late final OtherFollowingsBloc otherFollowingsBloc;

  @override
  void initState() {
    super.initState();
    otherFollowingsBloc = OtherFollowingsBloc(
        userRepository: context.read<UserRepository>(),
        userBloc: context.read<UserBloc>())
      ..add(LoadFollowing(id: widget.id));
  }

  @override
  void dispose() {
    otherFollowingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      height: 500,
      width: 600,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Following',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<OtherFollowingsBloc, OtherFollowingsState>(
              bloc: otherFollowingsBloc,
              builder: (context, state) {
                if (state is OtherFollowingLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is OtherFollowingOperationFailure) {
                  return Center(
                    child: ElevatedButton(
                        onPressed: () {
                          otherFollowingsBloc.add(LoadFollowing(id: widget.id));
                        },
                        child: Text("Try Again!")),
                  );
                }

                if (state is OtherFollowingOperationSuccess) {
                  final List<User> followings = state.followings;
                  return ListView.builder(
                    itemCount: followings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: profile_avatar(
                          imageUrl: followings[index].profilePicture == ''
                              ? ''
                              : 'http://10.0.2.2:3000/${followings[index].profilePicture!}',
                          radius: 50,
                          isAsset: followings[index].profilePicture == '',
                        ),
                        title: Text(followings[index].username!),
                        subtitle: Text(followings[index].fullName!),
                      );
                    },
                  );
                }
                return ErrorPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
