import 'package:flutter/material.dart';
import 'package:openwardrobe/models/user_profile.dart';
import 'package:openwardrobe/repositories/user_profile_repository.dart';
import 'package:openwardrobe/services/user_profile_service.dart';
import 'package:openwardrobe/services/wardrobe_service.dart';
import 'package:openwardrobe/repositories/wardrobe_repository.dart';
import 'package:openwardrobe/models/wardrobe_item.dart';
import 'package:openwardrobe/ui/widgets/wardrobe/item.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<UserProfile?> _fetchUserProfile() async {
    final userService = UserProfileService(UserProfileRepository());
    return await userService.getUserProfile();
  }

  Future<List<WardrobeItem>> _fetchPublicItems(String userId) async {
    final wardrobeService = WardrobeService(WardrobeRepository());
    return await wardrobeService.fetchPublicItemsByUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserProfile?>(
        future: _fetchUserProfile(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          } else if (userSnapshot.hasData) {
            final user = userSnapshot.data;
            return _buildProfileWithItems(context, user);
          } else {
            return const Center(child: Text('No profile data available'));
          }
        },
      ),
    );
  }

  Widget _buildProfileWithItems(BuildContext context, UserProfile? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileCard(context, user),
          const SizedBox(height: 20),
          if (user != null) _buildPublicItemsList(context, user.id),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile? user) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              const SizedBox(height: 20),
              Text(
                user?.displayName ?? 'No display name',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                "@${user?.username}",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              Text(
                user?.bio ?? 'No bio available',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
    ),
    );
  }

  Widget _buildPublicItemsList(BuildContext context, String userId) {
    return FutureBuilder<List<WardrobeItem>>(
      future: _fetchPublicItems(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading items: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wardrobe Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
               Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: snapshot.data?.map((item) {
          return WardrobeItemCard(
            item: item,
            onTap: () {
              
            },
          );
              }).toList() ?? [],
            ),
            ],
          );
        } else {
          return const Text('No public items available.');
        }
      },
    );
  }
}