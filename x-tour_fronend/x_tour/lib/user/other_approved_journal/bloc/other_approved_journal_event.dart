part of 'other_approved_journal_bloc.dart';

@immutable
abstract class OtherApprovedJournalEvent extends Equatable {
  const OtherApprovedJournalEvent();

  @override
  List<Object?> get props => [];
}

class GetApprovedJournals extends OtherApprovedJournalEvent {
  final String id;

  const GetApprovedJournals({required this.id});

  @override
  List<Object> get props => [];
}
