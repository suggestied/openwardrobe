import 'package:flutter/material.dart';
// import  waardrobe service from this project
import 'package:openwardrobe/services/wardrobe_service.dart';
import 'package:openwardrobe/repositories/wardrobe_repository.dart';
import 'package:openwardrobe/models/wardrobe_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  Future<List<WardrobeItem>> _getClothes() async {
    final wardrobeService = WardrobeService(WardrobeRepository());
    return await wardrobeService.getWardrobeItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Align(
  alignment: Alignment.topCenter, // Houdt de items bovenaan en gecentreerd horizontaal
  child: FutureBuilder<List<WardrobeItem>>(
    future: _getClothes(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        return Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
        );
      } else {
        return const Text('No data');
      }
    },
  ),
),

    );
  }
}
