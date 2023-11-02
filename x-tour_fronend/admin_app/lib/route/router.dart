import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../Screen/adminHome.dart';
import '../Screen/approve_pendingJournal.dart';
import '../Screen/approve_pending_post.dart';
import '../Screen/loginScreen.dart';
import '../Screen/webViewScreen.dart';
import '../admin/user/auth/bloc/auth_bloc.dart';
import '../theme/xTour_theme.dart';

final GlobalKey<NavigatorState> _rootNavigationKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionNavigationKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionKey');

class AppRoute extends StatelessWidget {
  final AuthBloc authBloc;
  AppRoute({super.key, required this.authBloc});

  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigationKey,
    initialLocation: '/',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return HomeScreen(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
                navigatorKey: _sectionNavigationKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: '/',
                      builder: (context, state) {
                        return PendingPostListScreen();
                      })
                ]),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                    path: '/pendingJournals',
                    builder: (context, state) {
                      return PendingJournalListScreen();
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'webview',
                        builder: (context, state) {
                          var query = state.queryParameters;
                          String title = query['link']!;
                          return WebViewScreen(title: title);
                        },
                      )
                    ]),
              ],
            ),
          ]),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      )
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authBloc.state is AuthAuthenticated;
      final bool initializing = authBloc.state is AuthInitializing;

      final bool loggingIn = state.location == '/login';

      if (!loggedIn) {
        return loggingIn
            ? null
            : initializing
                ? null
                : "/login";
      }
      if (loggingIn) {
        return "/";
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: XTourTheme().dark(),
      // darkTheme: XTourTheme().dark(),
      // themeMode: EasyDynamicTheme.of(context).themeMode,
      routerConfig: _router,
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     routerConfig: _router,
  //   )
  //   ;
  // }


