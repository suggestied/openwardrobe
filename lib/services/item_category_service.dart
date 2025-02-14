import 'package:openwardrobe/brick/models/Item_Category.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class ItemCategoryService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<ItemCategory>> getAll() async {
    return await appRepo.get<ItemCategory>();
  }

  Future<List<ItemCategory>> getById(String id) async {
    return await appRepo.get<ItemCategory>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(ItemCategory model) async {
    await appRepo.upsert<ItemCategory>(model);
  }
}
