import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';
import '../models/wardrobe_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WardrobeRepository {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<List<WardrobeItem>> fetchItems() async {
    final isOnline = await _checkConnectivity();
    if (isOnline) {
      final response = await supabaseClient.from('wardrobe').select().execute();
      final items = (response.data as List).map((item) => WardrobeItem.fromJson(item)).toList();
      await _cacheItemsLocally(items);
      return items;
    } else {
      return await _fetchItemsFromLocal();
    }
  }

  Future<void> addItem(WardrobeItem item) async {
    final isOnline = await _checkConnectivity();
    if (isOnline) {
      await supabaseClient.from('wardrobe').insert(item.toJson()).execute();
    } else {
      await _saveItemLocally(item, isSynced: false);
    }
  }

  Future<void> syncLocalChanges() async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    final unsyncedItems = box.values.where((item) => !item.isSynced).toList();

    for (var item in unsyncedItems) {
      await supabaseClient.from('wardrobe').insert(item.toJson()).execute();
      item.isSynced = true;
      await item.save();
    }
  }

  Future<void> _cacheItemsLocally(List<WardrobeItem> items) async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    await box.clear();
    for (var item in items) {
      await box.put(item.id, item);
    }
  }

  Future<List<WardrobeItem>> _fetchItemsFromLocal() async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    return box.values.toList();
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
