import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../user/bloc/user_bloc.dart';
import '../models/journal.dart';
import '../repository/journal_repository.dart';

part 'load_journal_event.dart';
part 'load_journal_state.dart';

class LoadJournalBloc extends Bloc<LoadJournalEvent, LoadJournalState> {
  final JournalRepository journalRepository;
  final UserBloc userBloc;
  LoadJournalBloc({required this.journalRepository, required this.userBloc})
      : super(LoadJournalInitial()) {
    on<LoadJournalEvent>(getJournals);
    on<LoadMoreJournals>(loadMoreJournals);
  }

  FutureOr<void> getJournals(event, emit) async {
    emit(JournalLoading());
    try {
      Map<String, dynamic> query = {
        "search": event.search,
        "perPage": event.limit,
        "page": event.page
      };
      final journals = await journalRepository.getJournals(query: query);
      emit(JournalsLoaded(journals: journals));
    } on Exception catch (e) {
      emit(JournalsFailed(error: e));
    }
  }

  FutureOr<void> loadMoreJournals(
      LoadMoreJournals event, Emitter<LoadJournalState> emit) async {
    // Todo:
  }
}
