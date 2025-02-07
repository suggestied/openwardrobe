import 'package:hive/hive.dart';

part 'wardrobe_item.g.dart'; 

@HiveType(typeId: 0)
class WardrobeItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? brandId;

  @HiveField(4)
  final String? categoryId;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  bool isSynced;  // For tracking sync status with Supabase

  WardrobeItem({
    required this.id,
    required this.userId,
    required this.name,
    this.brandId,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
  });

  // From Supabase JSON
  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      brandId: json['brand_id'],
      categoryId: json['category_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // To Supabase JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'brand_id': brandId,
        'category_id': categoryId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
