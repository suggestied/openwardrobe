import '../repositories/wardrobe_repository.dart';
import '../models/wardrobe_item.dart';

class WardrobeService {
  final WardrobeRepository wardrobeRepository;

  WardrobeService(this.wardrobeRepository);

  Future<List<WardrobeItem>> getWardrobeItems() async {
    return await wardrobeRepository.fetchItems();
  }

  Future<void> addWardrobeItem(WardrobeItem item) async {
    await wardrobeRepository.addItem(item);
  }

  Future<void> syncWardrobe() async {
    await wardrobeRepository.syncLocalChanges();
  }
}
