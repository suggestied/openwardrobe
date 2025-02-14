import 'package:get_it/get_it.dart';

import '../services/brand_service.dart';
import '../services/community_post_comment_service.dart';
import '../services/community_post_like_service.dart';
import '../services/community_post_service.dart';
import '../services/item_category_service.dart';
import '../services/item_metadata_service.dart';
import '../services/lookbook_item_service.dart';
import '../services/lookbook_service.dart';
import '../services/outfit_service.dart';
import '../services/outfit_item_service.dart';
import '../services/use_item_service.dart';
import '../services/use_outfit_service.dart';
import '../services/user_profile_service.dart';
import '../services/wardrobe_item_service.dart';
import '../repositories/app_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register the AppRepository instance.
  // Ensure that AppRepository.configure(...) is called before or within its constructor.
  getIt.registerLazySingleton<AppRepository>(() => AppRepository());

  // Register services. Each service should internally use GetIt.instance<AppRepository>()
  getIt.registerLazySingleton<BrandService>(() => BrandService());
  getIt.registerLazySingleton<CommunityPostCommentService>(() => CommunityPostCommentService());
  getIt.registerLazySingleton<CommunityPostLikeService>(() => CommunityPostLikeService());
  getIt.registerLazySingleton<CommunityPostService>(() => CommunityPostService());
  getIt.registerLazySingleton<ItemCategoryService>(() => ItemCategoryService());
  getIt.registerLazySingleton<ItemMetadataService>(() => ItemMetadataService());
  getIt.registerLazySingleton<LookbookItemService>(() => LookbookItemService());
  getIt.registerLazySingleton<LookbookService>(() => LookbookService());
  getIt.registerLazySingleton<OutfitService>(() => OutfitService());
  getIt.registerLazySingleton<OutfitItemService>(() => OutfitItemService());
  getIt.registerLazySingleton<UseItemService>(() => UseItemService());
  getIt.registerLazySingleton<UseOutfitService>(() => UseOutfitService());
  getIt.registerLazySingleton<UserProfileService>(() => UserProfileService());
  getIt.registerLazySingleton<WardrobeItemService>(() => WardrobeItemService());
}