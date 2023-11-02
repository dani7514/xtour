import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../journal/models/journal.dart';
import '../../../journal/repository/journal_repository.dart';
import '../../bloc/user_bloc.dart';
import '../../repository/user_repository.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class ApprovedJournalBloc
    extends Bloc<ApprovedJournalEvent, ApprovedJournalState> {
  final UserRepository userRepository;
  final JournalRepository journalRepository;
  final UserBloc userBloc;

  ApprovedJournalBloc(
      {required this.userRepository,
      required this.journalRepository,
      required this.userBloc})
      : super(ApprovedJournalInitial()) {
    on<GetApprovedJournals>(getJournals);
    on<DeleteApprovedJournal>(deleteJournal);
  }

  Future<FutureOr<void>> getJournals(event, emit) async {
    emit(ApprovedJournalLoading());
    // Map<String, dynamic> query = {
    //   "perPage": event.limit,
    //   "page": event.page,
    // };

    try {
      final response = await userRepository
          .getApprovedJournals((userBloc.state as UserOperationSuccess).user);
      emit(ApprovedJournalOperationSuccess(journals: response));
    } on Exception catch (e) {
      emit(ApprovedJournalOperationFailure(error: e));
    }
  }

  FutureOr<void> deleteJournal(
      DeleteApprovedJournal event, Emitter<ApprovedJournalState> emit) async {
    try {
      final List<Journal> journals =
          (state as ApprovedJournalOperationSuccess).journals;
      await journalRepository.deleteApprovedJournal(
          id: event.id, user: (userBloc.state as UserOperationSuccess).user);
      journals.removeWhere((element) => element.id == event.id);
      emit(ApprovedJournalOperationSuccess(journals: journals));
      userBloc.add(GetUser());
    } on Exception catch (e) {
      emit(ApprovedJournalOperationFailure(error: e));
    }
  }
}
