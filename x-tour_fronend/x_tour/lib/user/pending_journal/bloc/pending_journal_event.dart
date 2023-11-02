part of 'pending_journal_bloc.dart';

abstract class PendingJournalEvent extends Equatable {
  const PendingJournalEvent();

  @override
  List<Object> get props => [];
}

class GetPendingJournal extends PendingJournalEvent {
  // final int limit;
  // final int page;

  const GetPendingJournal();

  @override
  List<Object> get props => [];
}

class DeletePendingJournal extends PendingJournalEvent {
  final String id;

  const DeletePendingJournal({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdatePeningJournal extends PendingJournalEvent {
  final String journalId;
  final Journal? journal;
  final MultipartFile? image;

  const UpdatePeningJournal(
      {required this.journalId, this.journal, this.image});

  @override
  List<Object> get props => [journalId];
}
