import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/screens/error_page.dart';
import 'package:x_tour/user/follower/bloc/follower_bloc.dart';
import 'package:x_tour/user/following/bloc/following_bloc.dart';
import 'package:x_tour/user/models/user.dart';
import 'package:x_tour/user/repository/user_repository.dart';

import '../../custom/avator_custom.dart';
import '../bloc/user_bloc.dart' as ubloc;

class FollowerScreen extends StatefulWidget {
  const FollowerScreen({
    super.key,
  });

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  late FollowerBloc followerBloc;
  @override
  void initState() {
    super.initState();
    followerBloc = FollowerBloc(
        userRepository: context.read<UserRepository>(),
        userBloc: context.read<ubloc.UserBloc>())
      ..add(LoadFollower());
  }

  @override
  void dispose() {
    followerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      height: 500,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Followers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<FollowerBloc, FollowerState>(
              bloc: followerBloc,
              builder: (context, state) {
                if (state is FollowerLoading) {
                  //Todo:
                  return CircularProgressIndicator();
                }
                if (state is FollowerOperationFailure) {
                  return ElevatedButton(
                      onPressed: () {
                        followerBloc.add(LoadFollower());
                      },
                      child: Text("Try Again!"));
                }
                if (state is FollowerOperationSuccess) {
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
                        title: Text(
                          followers[index].username!,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          followers[index].fullName!,
                          style: TextStyle(fontSize: 15),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            if (true)
                              followerBloc
                                  .add(FollowUser(followers[index].id!));
                          },
                          child: true ? Text('Follow Back') : Text("Unfollow"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 6),
                          ),
                        ),
                      );
                    },
                  );
                }
                //TODO: Error Screen
                return ErrorPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class FollowerScreen extends StatefulWidget {
//   const FollowerScreen({Key? key}) : super(key: key);

//   @override
//   State<FollowerScreen> createState() => _FollowerScreenState();
// }

// class _FollowerScreenState extends State<FollowerScreen> {
//   late FollowerBloc followerBloc;
//   @override
//   void initState() {
//     super.initState();
//     followerBloc = FollowerBloc(
//         userRepository: context.read<UserRepository>(),
//         userBloc: context.read<ubloc.UserBloc>())
//       ..add(LoadFollower());
//   }

//   @override
//   void dispose() {
//     followerBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Followers'),
//       ),
//       body: BlocBuilder<FollowerBloc, FollowerState>(
//         builder: (context, state) {
//           if (state is FollowerLoading) {
//             //Todo:
//             return CircularProgressIndicator();
//           }
//           if (state is FollowerOperationFailure) {
//             return ElevatedButton(
//                 onPressed: () {
//                   followerBloc.add(LoadFollower());
//                 },
//                 child: Text("Try Again!"));
//           }
//           if (state is FollowerOperationSuccess) {
//             final List<User> followers = state.followers;
//             return ListView.separated(
//               padding: const EdgeInsets.all(20),
//               itemCount: followers.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         profile_avatar(
//                           imageUrl: followers[index].profilePicture == ''
//                               ? ''
//                               : followers[index].profilePicture!,
//                           radius: 60,
//                           isAsset: followers[index].profilePicture == '',
//                         ),
//                         const SizedBox(width: 20),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               followers[index].username,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               followers[index].fullName!,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ],
//                 );
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 return SizedBox(height: 10);
//               },
//             );
//           }
//           //TODO: Error Screen
//           return Center(child: Text("Error"));
//         },
//       ),
//     );
//   }
// }
