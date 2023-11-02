part of 'edit_journal_bloc.dart';

@immutable
abstract class EditJournalEvent extends Equatable {
  const EditJournalEvent();

  @override
  List<Object?> get props => [];
}

class LoadJournal extends EditJournalEvent {
  final String id;

  const LoadJournal({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateJournal extends EditJournalEvent {
  final String id;
  final Journal? journal;
  final MultipartFile? images;

  const UpdateJournal({required this.id, this.journal, this.images});
  @override
  List<Object?> get props => [id];
}
