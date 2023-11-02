// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_journal_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$PendingJournalService extends PendingJournalService {
  _$PendingJournalService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = PendingJournalService;

  @override
  Future<Response<List<Journal>>> getPendingJournals({
    required Map<String, dynamic> query,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/pending');
    final Map<String, dynamic> $params = query;
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<List<Journal>, Journal>($request);
  }

  @override
  Future<Response<Journal>> approvePendingJournal({
    required String id,
    required Journal journal,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final $body = journal;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<Journal, Journal>($request);
  }

  @override
  Future<Response<dynamic>> deletePendingJournal({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/pending/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
