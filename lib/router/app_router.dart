import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../ui/screens/home_page.dart';
import '../ui/screens/auth_page.dart';  
import '../ui/widgets/tab_scaffold.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    
    // Handle redirection based on auth status
    redirect: (BuildContext context, GoRouterState state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final isLoggingIn = state.uri.toString() == '/auth';

      if (!isLoggedIn && !isLoggingIn) {
        return '/auth';  // Redirect unauthenticated users to login
      } else if (isLoggedIn && isLoggingIn) {
        return '/home';  // Redirect logged-in users away from login
      }

      return null;  // No redirection needed
    },

    routes: [
      // Login Route (accessible without authentication)
      GoRoute(
        path: '/auth',
        name: 'Auth',
        pageBuilder: (context, state) => NoTransitionPage(child: AuthScreen()),
      ),

      // Protected Routes (require authentication)
      ShellRoute(
        builder: (context, state, child) {
          return TabScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'Home',
            pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
          ),
        //   We still need to wardrobe, analytics, and settings routes, and subroutes
        ],
      ),
    ],
  );
}
