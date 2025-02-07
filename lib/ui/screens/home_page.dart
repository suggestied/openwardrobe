import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: const Center(
        child: Text('Welcome to OpenWardrobe! You are logged in.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/wardrobe'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
