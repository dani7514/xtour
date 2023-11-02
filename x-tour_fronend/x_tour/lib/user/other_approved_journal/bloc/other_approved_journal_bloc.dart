import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/journal/repository/journal_repository.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/repository/user_repository.dart';

import '../../../journal/models/journal.dart';

part 'other_approved_journal_event.dart';
part 'other_approved_journal_state.dart';

class OtherApprovedJournalBloc
    extends Bloc<OtherApprovedJournalEvent, OtherApprovedJournalState> {
  final UserRepository userRepository;
  final JournalRepository journalRepository;
  final UserBloc userBloc;
  OtherApprovedJournalBloc({
    required this.journalRepository,
    required this.userBloc,
    required this.userRepository,
  }) : super(OtherApprovedJournalInitial()) {
    on<GetApprovedJournals>(getJournals);
  }

  FutureOr<void> getJournals(GetApprovedJournals event,
      Emitter<OtherApprovedJournalState> emit) async {
    emit(OtherApprovedJournalLoading());
    try {
      final response =
          await userRepository.getOtherUserApprovedJournals(event.id);
      emit(OtherApprovedJournalOperationSuccess(journals: response));
    } on Exception catch (e) {
      emit(OtherApprovedJournalOperationFailure(error: e));
    }
  }
}
