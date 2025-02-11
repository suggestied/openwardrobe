import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabScaffold extends StatelessWidget {
  final Widget child;

  const TabScaffold({Key? key, required this.child}) : super(key: key);

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/')) return 0;
    if (location.startsWith('/wardrobe')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;  // Default naar Home als geen match
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/wardrobe');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: 'Wardrobe'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          
        ],
      ),
    );
  }
}
