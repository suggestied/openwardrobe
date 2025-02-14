import 'package:openwardrobe/brick/models/Community_Post.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class CommunityPostService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<CommunityPost>> getAll() async {
    return await appRepo.get<CommunityPost>();
  }

  Future<List<CommunityPost>> getById(String id) async {
    return await appRepo.get<CommunityPost>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(CommunityPost model) async {
    await appRepo.upsert<CommunityPost>(model);
  }
}
