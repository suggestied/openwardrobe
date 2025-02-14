import 'package:openwardrobe/brick/models/Community_Post_Like.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class CommunityPostLikeService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<CommunityPostLike>> getAll() async {
    return await appRepo.get<CommunityPostLike>();
  }

  Future<List<CommunityPostLike>> getById(String id) async {
    return await appRepo.get<CommunityPostLike>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(CommunityPostLike model) async {
    await appRepo.upsert<CommunityPostLike>(model);
  }
}
