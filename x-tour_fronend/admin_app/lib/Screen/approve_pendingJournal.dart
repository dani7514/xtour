import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/admin/pending_journal/bloc/pending_journal_bloc.dart';
import 'package:x_tour/admin/pending_journal/repository/pending_journal_repository.dart';

import '../custom/approve_pendingJournal_card.dart';
// Replace 'path_to_Journal_card' with the actual path to your JournalCard widget

class PendingJournalListScreen extends StatefulWidget {
  @override
  State<PendingJournalListScreen> createState() =>
      _PendingJournalListScreenState();
}

class _PendingJournalListScreenState extends State<PendingJournalListScreen> {
  late final PendingJournalBloc pendingJournalBloc;

  @override
  void initState() {
    pendingJournalBloc = PendingJournalBloc(
        pendingJournalRepository: context.read<PendingJournalRepository>())
      ..add(const LoadPendingJournal());
    super.initState();
  }

  @override
  void dispose() {
    pendingJournalBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Journal List'),
      ),
      body: BlocBuilder<PendingJournalBloc, PendingJournalState>(
        bloc: pendingJournalBloc,
        builder: (context, state) {
          if (state is PendingJournalLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is PendingJournalFailure) {
            return Center(
              child: ElevatedButton(
                  onPressed: () {
                    pendingJournalBloc.add(const LoadPendingJournal());
                  },
                  child: Text("Try Again!")),
            );
          }
          if (state is PendingJournalLoaded) {
            final journals = state.journals;
            return ListView.builder(
              itemCount: journals.length,
              itemBuilder: (context, index) {
                final journal = journals[index];
                return PendingJournalCard(
                    journal: journal, pendingJournalBloc: pendingJournalBloc);
              },
            );
          }
          return Center(child: Text('Error'));
        },
      ),
    );
  }
}
