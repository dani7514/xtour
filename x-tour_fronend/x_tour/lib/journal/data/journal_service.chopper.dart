// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$JournalService extends JournalService {
  _$JournalService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = JournalService;

  @override
  Future<Response<List<Journal>>> getApprovedJournals({
    required Map<String, dynamic> query,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals');
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
  Future<Response<Journal>> getApprovedJournal({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<Journal, Journal>($request);
  }

  @override
  Future<Response<Journal>> getPendingJournal({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/pending/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<Journal, Journal>($request);
  }

  @override
  Future<Response<Journal>> createJournal({
    required Journal journal,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/pending');
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
  Future<Response<Journal>> insertImage({
    required String id,
    required MultipartFile image,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/pending/image/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<MultipartFile>(
        'image',
        image,
      )
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      headers: $headers,
    );
    return client.send<Journal, Journal>($request);
  }

  @override
  Future<Response<Journal>> updateJournal({
    required String id,
    required Journal journal,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/pending/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final $body = journal;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<Journal, Journal>($request);
  }

  @override
  Future<Response<dynamic>> deleteApprovedJournal({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('journals/${id}');
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
