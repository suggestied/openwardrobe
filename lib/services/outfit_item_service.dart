import 'package:openwardrobe/brick/models/Outfit_Item.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class OutfitItemService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<OutfitItem>> getAll() async {
    return await appRepo.get<OutfitItem>();
  }

  Future<List<OutfitItem>> getById(String id) async {
    return await appRepo.get<OutfitItem>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(OutfitItem model) async {
    await appRepo.upsert<OutfitItem>(model);
  }
}
