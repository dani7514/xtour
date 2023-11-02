import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../custom/custom.dart';
import '../journal/models/journal.dart';
import '../user/bloc/user_bloc.dart';
import '../user/models/user.dart';
import '../user/pending_journal/bloc/pending_journal_bloc.dart';

class PendingJournalCard extends StatefulWidget {
  PendingJournalCard({
    Key? key,
    required this.pendingJournalBloc,
    required this.journal,
    required this.user,
    required this.userBloc,
  }) : super(key: key);

  final Journal journal;
  final User user;
  final UserBloc userBloc;
  final PendingJournalBloc pendingJournalBloc;

  @override
  JournalState createState() => JournalState();
}

class JournalState extends State<PendingJournalCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Container(
        height: null,
        width: double.infinity,
        color: theme.cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            userCard(widget.user, widget.pendingJournalBloc, widget.journal),
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "http://10.0.2.2:3000/pending/${widget.journal.image!}",
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
                //   "http://10.0.2.2:3000/pending/${widget.journal.image!}",
                //   width: double.infinity,
                //   height: 400,
                //   fit: BoxFit.cover,
                // ),
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1],
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  bottom: 10,
                  child: IconButton(
                    onPressed: () {
                      GoRouter.of(context).go(
                          "/profile/pendingJournal/webview?link=${widget.journal.link}");
                    },
                    icon: iconBuilder(Icons.link),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Text(
                    widget.journal.title,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.journal.description,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userCard(
      User user, PendingJournalBloc pendingJournalBloc, Journal journal) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            profile_avatar(
              imageUrl: journal.creator!.profilePicture != ""
                  ? "http://10.0.2.2:3000/${journal.creator!.profilePicture!}"
                  : "assets/person_katz.jpeg",
              // TODO
              radius: 50,
              isAsset: journal.creator!.profilePicture == "",
            ),
            const SizedBox(width: 15),
            Text(
              journal.creator!.username!,
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                GoRouter.of(context).go(
                    '/profile/pendingJournal/editPendingJournal/${journal.id}');
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDeleteConfirmationDialog(
                    context, pendingJournalBloc, journal);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget iconBuilder(iconData) {
    return Icon(
      iconData,
      size: 35,
    );
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context,
      PendingJournalBloc pendingJournalBloc, Journal journal) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this journal?'),
              ],
            ),
          ),
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
                pendingJournalBloc.add(DeletePendingJournal(id: journal.id!));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
