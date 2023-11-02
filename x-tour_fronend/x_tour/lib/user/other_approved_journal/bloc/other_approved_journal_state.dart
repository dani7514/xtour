part of 'other_approved_journal_bloc.dart';

@immutable
abstract class OtherApprovedJournalState extends Equatable {
  const OtherApprovedJournalState();
  @override
  List<Object?> get props => [];
}

class OtherApprovedJournalInitial extends OtherApprovedJournalState {}

class OtherApprovedJournalLoading extends OtherApprovedJournalState {}

class OtherApprovedJournalOperationSuccess extends OtherApprovedJournalState {
  final List<Journal> journals;

  const OtherApprovedJournalOperationSuccess({required this.journals});

  @override
  List<Object> get props => [journals];
}

class OtherApprovedJournalOperationFailure extends OtherApprovedJournalState {
  final Exception error;

  const OtherApprovedJournalOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
