import 'package:openwardrobe/brick/models/Lookbook.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class LookbookService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<Lookbook>> getAll() async {
    return await appRepo.get<Lookbook>();
  }

  Future<List<Lookbook>> getById(String id) async {
    return await appRepo.get<Lookbook>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(Lookbook model) async {
    await appRepo.upsert<Lookbook>(model);
  }
}
