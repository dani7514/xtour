part of 'edit_journal_bloc.dart';

@immutable
abstract class EditJournalState extends Equatable {
  const EditJournalState();

  @override
  List<Object?> get props => [];
}

class EditJournalInitial extends EditJournalState {}

class EditJournalLoading extends EditJournalState {}

class EditJournalOperating extends EditJournalState {}

class EditJournalLoaded extends EditJournalState {
  final Journal journal;

  const EditJournalLoaded({required this.journal});
}

class EditJournalLoadFailure extends EditJournalState {}

class EditJournalOperationSuccess extends EditJournalState {}

class EditJournalOperationFailure extends EditJournalState {}
