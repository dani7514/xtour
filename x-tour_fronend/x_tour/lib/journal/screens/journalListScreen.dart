import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/custom/custom.dart';
import 'package:x_tour/journal/bloc/load_journal_bloc.dart';
import 'package:x_tour/journal/repository/journal_repository.dart';
import 'package:x_tour/journal/screens/create_journalScreen.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/screens/screens.dart';

import '../../user/models/user.dart';

class JournalListScreen extends StatefulWidget {
  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  late LoadJournalBloc loadJournalBloc;
  late User user;
  @override
  void initState() {
    super.initState();
    user = (context.read<UserBloc>().state as UserOperationSuccess).user;
    loadJournalBloc = LoadJournalBloc(
        journalRepository: context.read<JournalRepository>(),
        userBloc: context.read<UserBloc>())
      ..add(const LoadJournals());
  }

  @override
  void dispose() {
    loadJournalBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XTourAppBar(
        leading: Image(image: AssetImage('assets/Logo.png')),
        title: "Journal Post",
        showActionIcon: user.role!.contains("journalist")
            ? Transform.translate(
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
              )
            : Container(),
      ),
      body: BlocBuilder<LoadJournalBloc, LoadJournalState>(
        bloc: loadJournalBloc,
        builder: (context, state) {
          if (state is JournalLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is JournalsFailed) {
            return ElevatedButton(
                onPressed: () {
                  loadJournalBloc.add(const LoadJournals());
                },
                child: Text("Try Again!"));
          }

          if (state is JournalsLoaded) {
            final journals = state.journals;
            final user =
                (context.read<UserBloc>().state as UserOperationSuccess).user;
            return ListView.separated(
              itemCount: journals.length,
              itemBuilder: (context, index) {
                final journal = journals[index];
                return journalCard(
                  journal: journal,
                  user: user,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 20,
                );
              },
            );
          }
          return ElevatedButton(
              onPressed: () {
                loadJournalBloc.add(const LoadJournals());
              },
              child: Text("Try Again!"));
        },
      ),
    );
  }
}
