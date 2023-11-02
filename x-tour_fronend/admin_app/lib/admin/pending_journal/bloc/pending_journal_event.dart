part of 'pending_journal_bloc.dart';

abstract class PendingJournalEvent extends Equatable {
  const PendingJournalEvent();

  @override
  List<Object> get props => [];
}

class LoadPendingJournal extends PendingJournalEvent {
  final int limit;
  final int page;

  const LoadPendingJournal({this.limit = 20, this.page = 1});

  @override
  List<Object> get props => [limit, page];  
}

class LoadMorePendingJournal extends PendingJournalEvent {
  final int limit;
  final int page;

  const LoadMorePendingJournal({this.limit = 20, this.page = 1});

  @override
  List<Object> get props => [limit, page];
}

class ApprovePendingJournal extends LoadPendingJournal {
  final String id;
  final Journal journal;

  const ApprovePendingJournal({required this.id, required this.journal}); 

  @override
  List<Object> get props => [id, journal];
}

class DeletePendingJournal extends PendingJournalEvent {
  final String id;

  const DeletePendingJournal({required this.id});

  @override
  List<Object> get props => [id];
}