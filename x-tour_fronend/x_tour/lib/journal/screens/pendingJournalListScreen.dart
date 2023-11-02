import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/custom/custom.dart';
import 'package:x_tour/journal/screens/create_journalScreen.dart';

import '../../custom/pendingJournalCard.dart';
import '../../user/bloc/user_bloc.dart';
import '../../user/pending_journal/bloc/pending_journal_bloc.dart';
import '../models/journal.dart';

class PendingJournalListScreen extends StatefulWidget {
  @override
  State<PendingJournalListScreen> createState() =>
      _PendingJournalListScreenState();
}

class _PendingJournalListScreenState extends State<PendingJournalListScreen> {
  late PendingJournalBloc pendingJournalBloc;
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    pendingJournalBloc = context.read<PendingJournalBloc>()
      ..add(const GetPendingJournal());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingJournalBloc, PendingJournalState>(
      builder: (context, state) {
        if (state is PendingJournalLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PendingJournalOperationSuccess) {
          final List<Journal> journals = state.journals;
          return Scaffold(
            appBar: XTourAppBar(
              title: 'Pending Journal List',
              showActionIcon: Transform.translate(
                offset: const Offset(10, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateJournalScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: journals.length,
              itemBuilder: (context, index) {
                return PendingJournalCard(
                  pendingJournalBloc: pendingJournalBloc,
                  journal: journals[index],
                  user: (userBloc.state as UserOperationSuccess).user,
                  userBloc: userBloc,
                );
              },
            ),
          );
        }
        // TODO
        return Container();
      },
    );
  }
}
