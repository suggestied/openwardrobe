import 'package:openwardrobe/brick/models/Lookbook_Item.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class LookbookItemService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<LookbookItem>> getAll() async {
    return await appRepo.get<LookbookItem>();
  }

  Future<List<LookbookItem>> getById(String id) async {
    return await appRepo.get<LookbookItem>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(LookbookItem model) async {
    await appRepo.upsert<LookbookItem>(model);
  }
}
