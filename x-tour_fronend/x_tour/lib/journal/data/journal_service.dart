import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;

import '../models/journal.dart';

part 'journal_service.chopper.dart';

@ChopperApi(baseUrl: "journals")
abstract class JournalService extends ChopperService {
  @Get()
  Future<Response<List<Journal>>> getApprovedJournals(
      {@QueryMap() required Map<String, dynamic> query,
      @Header("Authorization") required String accesstoken});

  @Get(path: '/pending')
  Future<Response<List<Journal>>> getPendingJournals(
      {@QueryMap() required Map<String, dynamic> query,
      @Header("Authorization") required String accesstoken});

  @Get(path: '/{id}')
  Future<Response<Journal>> getApprovedJournal(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Get(path: 'pending/{id}')
  Future<Response<Journal>> getPendingJournal(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Post(path: '/pending', optionalBody: true)
  Future<Response<Journal>> createJournal(
      {@Body() required Journal journal,
      @Header("Authorization") required String accesstoken});

  @Post(path: '/pending/image/{id}', optionalBody: true)
  @Multipart()
  Future<Response<Journal>> insertImage(
      {@Path('id') required String id,
      @PartFile("image") required MultipartFile image,
      @Header("Authorization") required String accesstoken});

  @Patch(path: '/pending/{id}', optionalBody: true)
  Future<Response<Journal>> updateJournal(
      {@Path('id') required String id,
      @Body() required Journal journal,
      @Header("Authorization") required String accesstoken});

  @Delete(path: '/{id}')
  Future<Response> deleteApprovedJournal(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Delete(path: 'pending/{id}')
  Future<Response> deletePendingJournal(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  static JournalService create([ChopperClient? client]) =>
      _$JournalService(client);
}
