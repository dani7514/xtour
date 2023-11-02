part of 'journal_bloc.dart';

abstract class ApprovedJournalEvent extends Equatable {
  const ApprovedJournalEvent();

  @override
  List<Object> get props => [];
}

class GetApprovedJournals extends ApprovedJournalEvent {
  // final int limit;
  // final int page;

  const GetApprovedJournals();

  @override
  List<Object> get props => [];
}

class DeleteApprovedJournal extends ApprovedJournalEvent {
  final String id;

  const DeleteApprovedJournal({required this.id});

  @override
  List<Object> get props => [id];
}
