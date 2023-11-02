import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/journal/models/journal.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:x_tour/journal/repository/journal_repository.dart';

part 'edit_journal_event.dart';
part 'edit_journal_state.dart';

class EditJournalBloc extends Bloc<EditJournalEvent, EditJournalState> {
  final JournalRepository journalRepository;
  EditJournalBloc({required this.journalRepository})
      : super(EditJournalInitial()) {
    on<LoadJournal>(loadJournal);
    on<UpdateJournal>(updateJournal);
  }

  FutureOr<void> updateJournal(
      UpdateJournal event, Emitter<EditJournalState> emit) async {
    Journal journal = (state as EditJournalLoaded).journal;
    emit(EditJournalLoading());
    try {
      if (event.journal != null) {
        journal = await journalRepository.updateJournal(
            id: event.id, journal: event.journal!);
      }
      if (event.images != null) {
        journal = await journalRepository.insertImage(
            id: event.id, image: event.images!);
      }
      emit(EditJournalOperationSuccess());
    } on Exception catch (_) {
      emit(EditJournalLoadFailure());
    }
  }

  FutureOr<void> loadJournal(
      LoadJournal event, Emitter<EditJournalState> emit) async {
    emit(EditJournalLoading());
    try {
      final journal = await journalRepository.getPendingJournal(event.id);
      emit(EditJournalLoaded(journal: journal));
    } catch (e) {
      emit(EditJournalLoadFailure());
    }
  }
}
