import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openwardrobe/ui/screens/wardrobe/item/page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../ui/screens/auth/page.dart';  
import '../ui/screens/home/page.dart';
import '../ui/screens/wardrobe/page.dart';
import '../ui/screens/profile/page.dart';
import '../ui/screens/profile/settings/page.dart';

import '../ui/widgets/tab_scaffold.dart';


class AppRouter {

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    
    redirect: (BuildContext context, GoRouterState state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final isLoggingIn = state.uri.toString() == '/auth';

      if (!isLoggedIn && !isLoggingIn) {
        return '/auth';
      } else if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/auth',
        name: 'Auth',
        pageBuilder: (context, state) => NoTransitionPage(child: AuthScreen()),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return TabScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'Home',
            pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/wardrobe',
            name: 'Wardrobe',
            pageBuilder: (context, state) => NoTransitionPage(child: WardrobeScreen()),
          ),
          GoRoute(
            path: '/profile',
            name: 'Profile',
            pageBuilder: (context, state) => NoTransitionPage(child: ProfileScreen()),
          ),
          // Settings
          GoRoute(path: '/settings', name: 'Settings', pageBuilder: (context, state) => NoTransitionPage(child: SettingsPage())),

          GoRoute(
            path: '/wardrobe/:id',
            name: 'WardrobeItem',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage(child: WardrobeItemPage(id: id));
            },
          ),
        ],
      ),
    ],
  );
}
