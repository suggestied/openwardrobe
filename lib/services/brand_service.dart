import 'package:openwardrobe/brick/models/Brand.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class BrandService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<Brand>> getAll() async {
    return await appRepo.get<Brand>();
  }

  Future<List<Brand>> getById(String id) async {
    return await appRepo.get<Brand>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(Brand model) async {
    await appRepo.upsert<Brand>(model);
  }
}
