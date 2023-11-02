part of 'load_journal_bloc.dart';

abstract class LoadJournalState extends Equatable {
  const LoadJournalState();

  @override
  List<Object> get props => [];
}

class LoadJournalInitial extends LoadJournalState {}

class JournalLoading extends LoadJournalState {}

class JournalsLoaded extends LoadJournalState {
  final List<Journal> journals;

  const JournalsLoaded({required this.journals});

  @override
  List<Object> get props => [journals];
}

class JournalsLoadMoreFailed extends LoadJournalState {
  final Exception error;

  const JournalsLoadMoreFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class JournalsFailed extends LoadJournalState {
  final Exception error;

  const JournalsFailed({required this.error});

  @override
  List<Object> get props => [error];
}
