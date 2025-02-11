import 'package:flutter/material.dart';
import 'package:openwardrobe/models/user_profile.dart';
import 'package:openwardrobe/repositories/user_profile_repository.dart';
import 'package:openwardrobe/services/user_profile_service.dart';
// import  waardrobe service from this project
import 'package:openwardrobe/services/wardrobe_service.dart';
import 'package:openwardrobe/repositories/wardrobe_repository.dart';
import 'package:openwardrobe/models/wardrobe_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  Future<UserProfile?> _getUser() async {
    final userService = UserProfileService(UserProfileRepository());
    final userProfile = await userService.getUserProfile();
    return userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Align(
  alignment: Alignment.topCenter, // Houdt de items bovenaan en gecentreerd horizontaal
  child: 
  FutureBuilder<UserProfile?>(
    future: _getUser(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        final user = snapshot.data;
        return Column(
          children: [
            // Max width with child
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400, // Max breedte per item
              ),
              child:
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name: ${user?.username}'),
                Text('displayname: ${user?.displayName}'),
              ],
            ),
            ),
          ],
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
