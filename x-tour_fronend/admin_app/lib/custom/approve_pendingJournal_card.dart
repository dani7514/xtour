import 'package:flutter/material.dart';
import 'package:x_tour/admin/pending_journal/model/journal.dart';
import 'package:x_tour/custom/pofile_avatar.dart';

import '../admin/pending_journal/bloc/pending_journal_bloc.dart';

class PendingJournalCard extends StatefulWidget {
  PendingJournalCard({
    super.key,
    required this.pendingJournalBloc,
    required this.journal,
  });

  final Journal journal;
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 10,
            ),
            userCard(),
            Stack(
              children: [
                Image.network(
                  'http://10.0.2.2:3000/pending/${widget.journal.image}',
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
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
                        onPressed: () => {
                              // handle the click
                            },
                        icon: iconBuilder(Icons.link)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                Text(
                  widget.journal.title,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.journal.description,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
            ),
          ])),
    );
  }

  Widget userCard() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Row(children: [
        profile_avatar(
          imageUrl: widget.journal.creator!.profilePicture != ""
              ? "http://10.0.2.2:3000/pending${widget.journal.creator!.profilePicture!}"
              : "./assets/person_kelvin copy.jpg",
          // TODO
          radius: 50,
          isAsset: widget.journal.creator!.profilePicture == "",
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          widget.journal.creator!.username,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            widget.pendingJournalBloc.add(ApprovePendingJournal(
                id: widget.journal.id!, journal: widget.journal));
          },
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            widget.pendingJournalBloc
                .add(DeletePendingJournal(id: widget.journal.id!));
          },
        ),
      ]),
    );
  }

  Widget iconBuilder(iconData) {
    return Icon(
      iconData,
      size: 35,
    );
  }
}
