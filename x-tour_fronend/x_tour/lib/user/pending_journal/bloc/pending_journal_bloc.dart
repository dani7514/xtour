import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' show MultipartFile;

import '../../../journal/models/journal.dart';
import '../../../journal/repository/journal_repository.dart';
import '../../bloc/user_bloc.dart';
import '../../repository/user_repository.dart';

part 'pending_journal_event.dart';
part 'pending_journal_state.dart';

class PendingJournalBloc
    extends Bloc<PendingJournalEvent, PendingJournalState> {
  final UserRepository userRepository;
  final JournalRepository journalRepository;
  final UserBloc userBloc;
  PendingJournalBloc(
      {required this.userRepository,
      required this.journalRepository,
      required this.userBloc})
      : super(PendingJournalInitial()) {
    on<GetPendingJournal>(getPendingJournal);
    on<DeletePendingJournal>(deletePendingJournal);
    on<UpdatePeningJournal>(updatePendingJournal);
  }
  Future<FutureOr<void>> getPendingJournal(
      GetPendingJournal event, Emitter<PendingJournalState> emit) async {
    emit(PendingJournalLoading());
    // Map<String, dynamic> query = {
    //   "perPage": event.limit,
    //   "page": event.page,
    // };

    try {
      final response = await userRepository
          .getPendingJournals((userBloc.state as UserOperationSuccess).user);
      emit(PendingJournalOperationSuccess(journals: response));
    } on Exception catch (e) {
      emit(PendingJournalOperationFailure(error: e));
    }
  }

  Future<FutureOr<void>> deletePendingJournal(
      DeletePendingJournal event, Emitter<PendingJournalState> emit) async {
    try {
      final List<Journal> journals =
          (state as PendingJournalOperationSuccess).journals;
      await journalRepository.deletePendingJournal(
          id: event.id, user: (userBloc.state as UserOperationSuccess).user);
      journals.removeWhere((element) => element.id == event.id);
      emit(PendingJournalLoading());
      emit(PendingJournalOperationSuccess(journals: journals));
      userBloc.add(GetUser());
    } on Exception catch (e) {
      emit(PendingJournalOperationFailure(error: e));
    }
  }

  Future<FutureOr<void>> updatePendingJournal(
      UpdatePeningJournal event, Emitter<PendingJournalState> emit) async {
    emit(PendingJournalLoading());
    try {
      final List<Journal> journals =
          (state as PendingJournalOperationSuccess).journals;

      Journal journal =
          journals.firstWhere((element) => element.id == event.journalId);
      if (event.journal != null) {
        journal = await journalRepository.updateJournal(
            id: event.journalId, journal: event.journal!);
      }

      if (event.image != null) {
        journal = await journalRepository.insertImage(
            id: event.journalId, image: event.image!);
      }

      final newJournals = journals
          .map((element) => element.id == journal.id ? journal : element)
          .toList();
      emit(PendingJournalOperationSuccess(journals: newJournals));
    } on Exception catch (e) {
      emit(PendingJournalOperationFailure(error: e));
    }
  }
}
