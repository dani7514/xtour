import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/screens/error_page.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/others_follower/bloc/other_followers_bloc.dart';
import 'package:x_tour/user/repository/user_repository.dart';

import '../../custom/avator_custom.dart';
import '../models/user.dart';

class OthersFollower extends StatefulWidget {
  const OthersFollower({
    super.key,
    required this.id,
  });

  final String id;

  // final List<String> usernames;
  // final List<String> names;

  @override
  State<OthersFollower> createState() => _OthersFollowerState();
}

class _OthersFollowerState extends State<OthersFollower> {
  late OtherFollowersBloc otherFollowersBloc;

  @override
  void initState() {
    super.initState();
    otherFollowersBloc = OtherFollowersBloc(
        userBloc: context.read<UserBloc>(),
        userRepository: context.read<UserRepository>())
      ..add(LoadFollower(id: widget.id));
  }

  @override
  void dispose() {
    otherFollowersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      height: 500,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Followers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<OtherFollowersBloc, OtherFollowersState>(
              bloc: otherFollowersBloc,
              builder: (context, state) {
                if (state is OtherFollowerLoading) {
                  //Todo:
                  return CircularProgressIndicator();
                }
                if (state is OtherFollowerOperationFailure) {
                  return Center(
                    child: ElevatedButton(
                        onPressed: () {
                          otherFollowersBloc.add(LoadFollower(id: widget.id));
                        },
                        child: Text("Try Again!")),
                  );
                }

                if (state is OtherFollowerOperationSuccess) {
                  final List<User> followers = state.followers;
                  return ListView.builder(
                    itemCount: followers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: profile_avatar(
                          imageUrl: followers[index].profilePicture == ''
                              ? ''
                              : "http://10.0.2.2:3000/${followers[index].profilePicture!}",
                          radius: 50,
                          isAsset: followers[index].profilePicture == '',
                        ),
                        title: Text(followers[index].username!),
                        subtitle: Text(followers[index].fullName!),
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
