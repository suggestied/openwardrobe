import 'package:openwardrobe/brick/models/Use_Item.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class UseItemService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<UseItem>> getAll() async {
    return await appRepo.get<UseItem>();
  }

  Future<List<UseItem>> getById(String id) async {
    return await appRepo.get<UseItem>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(UseItem model) async {
    await appRepo.upsert<UseItem>(model);
  }
}
