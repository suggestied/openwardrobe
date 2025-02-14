import 'package:openwardrobe/brick/models/User_Profile.model.dart';
import 'package:brick_core/query.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:get_it/get_it.dart';

class UserProfileService {
  final appRepo = GetIt.instance<AppRepository>();

  Future<List<UserProfile>> getAll() async {
    return await appRepo.get<UserProfile>();
  }

  Future<List<UserProfile>> getById(String id) async {
    return await appRepo.get<UserProfile>(query: Query.where('id', id, limit1: true));
  }

  Future<void> upsert(UserProfile model) async {
    await appRepo.upsert<UserProfile>(model);
  }
}
