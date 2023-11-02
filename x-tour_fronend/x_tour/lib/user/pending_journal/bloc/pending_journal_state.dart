part of 'pending_journal_bloc.dart';

abstract class PendingJournalState extends Equatable {
  const PendingJournalState();

  @override
  List<Object> get props => [];
}

class PendingJournalInitial extends PendingJournalState {}

class PendingJournalLoading extends PendingJournalState {}

class PendingJournalOperationSuccess extends PendingJournalState {
  final List<Journal> journals;

  const PendingJournalOperationSuccess({required this.journals});

  @override
  List<Object> get props => [journals];
}

class PendingJournalOperationFailure extends PendingJournalState {
  final Exception error;

  const PendingJournalOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
