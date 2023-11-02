part of 'load_journal_bloc.dart';

abstract class LoadJournalEvent extends Equatable {
  const LoadJournalEvent();

  @override
  List<Object> get props => [];
}

class LoadJournals extends LoadJournalEvent {
  final String search;
  final int limit;
  final int page;

  const LoadJournals({this.search = "", this.limit = 20, this.page = 1});

  @override
  List<Object> get props => [limit, page, search];
}

class LoadMoreJournals extends LoadJournalEvent {
  final String search;
  final int limit;
  final int page;

  const LoadMoreJournals({this.search = "", this.limit = 20, this.page = 1});

  @override
  List<Object> get props => [limit, page, search];
}
