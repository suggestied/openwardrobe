import 'package:flutter/material.dart';
import 'package:openwardrobe/brick/models/Wardrobe_Item.model.dart';
import 'package:openwardrobe/services/wardrobe_item_service.dart';
// import  waardrobe service from this project
import 'package:get_it/get_it.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Welcome, username and profile picture
        title: const Text('Wardrobe'),
      ),
      body: Align(
          alignment: Alignment
              .topCenter, // Houdt de items bovenaan en gecentreerd horizontaal
          child: Column(
            // DashboardLink
            children: [
              // Max width for row
              const SizedBox(height: 20),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: FutureBuilder<List<WardrobeItem>>(
                    future: GetIt.instance<WardrobeItemService>().getAll(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final items = snapshot.data ?? [];

                      if (items.isEmpty) {
                        return const Center(child: Text('No items found'));
                      }

                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(title: Text("test"));
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}
