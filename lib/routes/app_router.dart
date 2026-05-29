import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/create_task_screen.dart';
import '../screens/edit_task_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/task_detail_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      // HomeScreen - Dashboard Principal
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      
      // CreateTaskScreen - Slide desde abajo con fade
      GoRoute(
        path: '/create',
        name: 'create',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const CreateTaskScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.35), // Desliza sutilmente desde abajo
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeInCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 250),
          );
        },
      ),
      
      // EditTaskScreen - Slide desde abajo con fade
      GoRoute(
        path: '/edit/:id',
        name: 'edit',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final taskId = state.pathParameters['id'] ?? '';
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: EditTaskScreen(taskId: taskId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.35), // Desliza sutilmente desde abajo
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeInCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 250),
          );
        },
      ),

      // TaskDetailScreen - Slide desde la derecha con fade
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final taskId = state.pathParameters['id'] ?? '';
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: TaskDetailScreen(taskId: taskId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0), // Desliza sutilmente desde la derecha
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 280),
          );
        },
      ),

      // StatsScreen - Slide desde la derecha con fade
      GoRoute(
        path: '/stats',
        name: 'stats',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const StatsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0), // Desliza sutilmente desde la derecha
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 280),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Pantalla no encontrada: ${state.error}'),
      ),
    ),
  );
}
