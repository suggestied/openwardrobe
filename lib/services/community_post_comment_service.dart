import 'package:openwardrobe/brick/models/community_post_comment.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class CommunityPostCommentService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<CommunityPostComment>> getAll() async {
    return await appRepo.get<CommunityPostComment>();
  }

  Future<List<CommunityPostComment>> getById(String id) async {
    return await appRepo.get<CommunityPostComment>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(CommunityPostComment model) async {
    await appRepo.upsert<CommunityPostComment>(model);
  }
}
