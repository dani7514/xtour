part of 'journal_bloc.dart';

abstract class ApprovedJournalState extends Equatable {
  const ApprovedJournalState();

  @override
  List<Object> get props => [];
}

class ApprovedJournalInitial extends ApprovedJournalState {}

class ApprovedJournalLoading extends ApprovedJournalState {}

class ApprovedJournalOperationSuccess extends ApprovedJournalState {
  final List<Journal> journals;

  const ApprovedJournalOperationSuccess({required this.journals});

  @override
  List<Object> get props => [journals];
}

class ApprovedJournalOperationFailure extends ApprovedJournalState {
  final Exception error;

  const ApprovedJournalOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
