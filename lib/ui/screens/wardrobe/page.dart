import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openwardrobe/services/wardrobe_service.dart';
import 'package:openwardrobe/repositories/wardrobe_repository.dart';
import 'package:openwardrobe/models/wardrobe_item.dart';
import 'package:openwardrobe/ui/widgets/wardrobe/item.dart';
// WarderobeCategory
import 'package:openwardrobe/ui/widgets/wardrobe/category.dart';


class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});
  Future<List<WardrobeItem>> _getClothes() async {
    final wardrobeService = WardrobeService(WardrobeRepository());
    return await wardrobeService.getWardrobeItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe'),
        actions: [],
      ),
      body: Align(
  alignment: Alignment.topCenter,
  child: FutureBuilder<List<WardrobeItem>>(
    future: _getClothes(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        final clothes = snapshot.data;
        return Column(
          children: [
            // Max width with child
            
            // Add search bar

            // Create search bar using material
            // In a column with padding
            // Padding
            // Search bar

          ConstrainedBox(constraints: BoxConstraints(maxWidth: 500),
          child: 
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                    // Icon
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                  ),
                  ),
                ),
              ],
            ),
          ),


            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: clothes?.map((item) {
          return WardrobeItemCard(
            item: item,
            onTap: () {
              context.go('/wardrobe/${item.id}');
            },
          );
              }).toList() ?? [],
            ),
          ],
        );
      } else {
        return const Text('No data');
      }
    },
  ),
),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/wardrobe'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
