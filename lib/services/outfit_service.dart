import 'package:openwardrobe/brick/models/Outfit.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class OutfitService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<Outfit>> getAll() async {
    return await appRepo.get<Outfit>();
  }

  Future<List<Outfit>> getById(String id) async {
    return await appRepo.get<Outfit>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(Outfit model) async {
    await appRepo.upsert<Outfit>(model);
  }
}
