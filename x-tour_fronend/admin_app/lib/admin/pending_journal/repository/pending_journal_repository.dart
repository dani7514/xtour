import 'package:x_tour/admin/pending_journal/data/pending_journal_service.dart';
import 'package:x_tour/admin/pending_journal/model/journal.dart';
import 'package:x_tour/admin/user/auth/bloc/auth_bloc.dart';

class PendingJournalRepository {
  final PendingJournalService pendingJournalService;
  final AuthBloc authBloc;

  const PendingJournalRepository(
      {required this.pendingJournalService, required this.authBloc});

  Future<List<Journal>> getPendingJournal(Map<String, dynamic> query) async {
    final response = await pendingJournalService.getPendingJournals(
        query: query, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body!;
    }
    if (response.statusCode == 401) {
      authBloc.add(LogOut());
    }
    throw Exception(response.error);
  }

  Future<Journal> approvePendingJournal(String id, Journal journal) async {
    journal.id = null;
    final response = await pendingJournalService.approvePendingJournal(
        id: id, journal: journal, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body!;
    }
    if (response.statusCode == 401) {
      authBloc.add(LogOut());
    }
    throw Exception(response.error);
  }

  Future<void> deletePendingJournal({required String id}) async {
    final response = await pendingJournalService.deletePendingJournal(
        id: id, accesstoken: getAccessHeader());
    if (response.statusCode == 401) {
      authBloc.add(LogOut());
    }
    if (!response.isSuccessful) {
      throw Exception("Something went wrong");
    }
  }

  String getAccessHeader() {
    String at = (authBloc.state as AuthAuthenticated).accessToken;
    return "Bearer $at";
  }
}
