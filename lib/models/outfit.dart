import 'package:hive/hive.dart';

part 'outfit.g.dart';

@HiveType(typeId: 1)
class Outfit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  List<String> wardrobeItemIds;  // To link wardrobe items to the outfit

  @HiveField(6)
  bool isSynced;

  Outfit({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.wardrobeItemIds = const [],
    this.isSynced = true,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      wardrobeItemIds: List<String>.from(json['wardrobe_item_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'wardrobe_item_ids': wardrobeItemIds,
      };
}
