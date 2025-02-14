import 'package:openwardrobe/brick/models/Wardrobe_Item.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class WardrobeItemService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<WardrobeItem>> getAll() async {
    return await appRepo.get<WardrobeItem>();
  }

  Future<List<WardrobeItem>> getById(String id) async {
    return await appRepo.get<WardrobeItem>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(WardrobeItem model) async {
    await appRepo.upsert<WardrobeItem>(model);
  }
}
