import 'package:flutter/material.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';

class WardrobeItemComponent extends StatelessWidget {
  final WardrobeItem item;

  const WardrobeItemComponent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Wardrobe Item: ${item.imagePath}'),
      ],
    );
  }
}