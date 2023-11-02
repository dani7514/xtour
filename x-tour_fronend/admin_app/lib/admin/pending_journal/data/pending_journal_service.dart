import 'package:chopper/chopper.dart';
import 'package:x_tour/admin/pending_journal/model/journal.dart';

part 'pending_journal_service.chopper.dart';

@ChopperApi(baseUrl: "journals")
abstract class PendingJournalService extends ChopperService {
  @Get(path: '/pending')
  Future<Response<List<Journal>>> getPendingJournals(
      {@QueryMap() required Map<String, dynamic> query,
      @Header("Authorization") required String accesstoken});
    
  @Post(path: '/{id}')  
  Future<Response<Journal>> approvePendingJournal({@Path("id") required String id, @Body() required Journal journal, @Header("Authorization") required String accesstoken});

  @Delete(path: 'pending/{id}')
  Future<Response> deletePendingJournal(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  static PendingJournalService create([ChopperClient? client]) => _$PendingJournalService(client);
}