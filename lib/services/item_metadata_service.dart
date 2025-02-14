import 'package:openwardrobe/brick/models/Item_Metadata.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class ItemMetadataService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<ItemMetadata>> getAll() async {
    return await appRepo.get<ItemMetadata>();
  }

  Future<List<ItemMetadata>> getById(String id) async {
    return await appRepo.get<ItemMetadata>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(ItemMetadata model) async {
    await appRepo.upsert<ItemMetadata>(model);
  }
}
