import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
// import  waardrobe service from this project
import 'package:openwardrobe/services/wardrobe_service.dart';
import 'package:openwardrobe/repositories/wardrobe_repository.dart';
import 'package:openwardrobe/models/wardrobe_item.dart';
import 'package:openwardrobe/ui/widgets/wardrobe/item.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  Future<List<WardrobeItem>> _getClothes() async {
    final wardrobeService = WardrobeService(WardrobeRepository());
    return await wardrobeService.getWardrobeItems();
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;




    Future<void> _signOut() async {
      await supabase.auth.signOut();
      if (context.mounted) context.go('/');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body: Center(
        // A dashboard with all the wardrobe items
        child: FutureBuilder<List<WardrobeItem>>(
          future: _getClothes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final clothes = snapshot.data;
              return ListView.builder(
                itemCount: clothes?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = clothes![index];
                  //WardrobeItemCard
                  return WardrobeItemCard(
                    item: item,
                    onTap: () => context.go('/wardrobe/${item.id}'),
                  );
                },
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
