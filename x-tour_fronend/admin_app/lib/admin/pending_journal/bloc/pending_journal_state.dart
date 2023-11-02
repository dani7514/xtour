part of 'pending_journal_bloc.dart';

abstract class PendingJournalState extends Equatable {
  const PendingJournalState();
  
  @override
  List<Object> get props => [];
}

class PendingJournalInitial extends PendingJournalState {}

class PendingJournalLoading extends PendingJournalState {}

class PendingJournalLoaded extends PendingJournalState{
  final List<Journal> journals;

  const PendingJournalLoaded({required this.journals});

  @override
  List<Object> get props => [journals];
}

class PendingJournalFailure extends PendingJournalState{
  final Exception error;

  const PendingJournalFailure({required this.error});

  @override
  List<Object> get props => [error];
}