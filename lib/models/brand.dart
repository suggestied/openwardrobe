import 'package:hive/hive.dart';

part 'brand.g.dart';

@HiveType(typeId: 2)
class Brand extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String userId;

  Brand({
    required this.id,
    required this.name,
    required this.userId,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'user_id': userId,
      };
}
