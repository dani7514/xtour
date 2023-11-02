import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:x_tour/admin/pending_journal/model/journal.dart';
import 'package:x_tour/admin/pending_journal/repository/pending_journal_repository.dart';
part 'pending_journal_event.dart';
part 'pending_journal_state.dart';

class PendingJournalBloc
    extends Bloc<PendingJournalEvent, PendingJournalState> {
  final PendingJournalRepository pendingJournalRepository;
  PendingJournalBloc({required this.pendingJournalRepository})
      : super(PendingJournalInitial()) {
    on<LoadPendingJournal>(loadJournal);
    on<LoadMorePendingJournal>(loadMoreJournal);
    on<ApprovePendingJournal>(approveJournal);
    on<DeletePendingJournal>(deleteJournal);
  }

  FutureOr<void> loadJournal(
      LoadPendingJournal event, Emitter<PendingJournalState> emit) async {
    emit(PendingJournalLoading());
    try {
      Map<String, dynamic> query = {"perPage": event.limit, "page": event.page};
      final List<Journal> journals =
          await this.pendingJournalRepository.getPendingJournal(query);
      // emit(PendingJournalLoading());
      emit(PendingJournalLoaded(journals: journals));
    } on Exception catch (e) {
      emit(PendingJournalFailure(error: e));
    }
  }

  FutureOr<void> loadMoreJournal(
      LoadMorePendingJournal event, Emitter<PendingJournalState> emit) async {
    final List<Journal> journals = (state as PendingJournalLoaded).journals;
    try {
      Map<String, dynamic> query = {"perPage": event.limit, "page": event.page};
      final response = await pendingJournalRepository.getPendingJournal(query);
      journals.addAll(response);
      emit(PendingJournalLoaded(journals: journals));
    } catch (_) {}
  }

  FutureOr<void> approveJournal(
      ApprovePendingJournal event, Emitter<PendingJournalState> emit) async {
    try {
      await pendingJournalRepository.approvePendingJournal(
          event.id, event.journal);
      final List<Journal> journals =
          await this.pendingJournalRepository.getPendingJournal({});
      emit(PendingJournalLoading());
      emit(PendingJournalLoaded(journals: journals));
    } catch (_) {}
  }

  FutureOr<void> deleteJournal(
      DeletePendingJournal event, Emitter<PendingJournalState> emit) async {
    final journals = (state as PendingJournalLoaded).journals;
    try {
      await pendingJournalRepository.deletePendingJournal(id: event.id);
      journals.removeWhere((element) => element.id == event.id);
      emit(PendingJournalLoading());
      emit(PendingJournalLoaded(journals: journals));
    } catch (_) {}
  }
}
