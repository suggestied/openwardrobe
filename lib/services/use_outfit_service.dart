import 'package:openwardrobe/brick/models/Use_Outfit.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class UseOutfitService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<UseOutfit>> getAll() async {
    return await appRepo.get<UseOutfit>();
  }

  Future<List<UseOutfit>> getById(String id) async {
    return await appRepo.get<UseOutfit>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(UseOutfit model) async {
    await appRepo.upsert<UseOutfit>(model);
  }
}
