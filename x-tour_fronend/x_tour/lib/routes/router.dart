import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x_tour/user/screens/othersProfileScreen.dart';
import 'package:x_tour/user/auth/bloc/auth_bloc.dart';
import '../journal/screens/journalListScreen.dart';
import '../journal/screens/pendingJournalListScreen.dart';
import '../journal/screens/webViewScreen.dart';
import '../posts/screens/editPendingPostScreen.dart';
import '../posts/screens/pendingPostListScreen.dart';
import '../posts/screens/postDetail.dart';
import '../posts/screens/postListScreen.dart';
import '../posts/screens/searchScreen.dart';
import '../user/screens/editProfileScreen.dart';
import '../user/screens/profileScreen.dart';
import '../screens/screens.dart';
import '../theme/xTour_theme.dart';

final GlobalKey<NavigatorState> _rootNavigationKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionNavigationKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionKey');

class AppRoute extends StatelessWidget {
  final AuthBloc authBloc;

  AppRoute({super.key, required this.authBloc});

  // ignore: prefer_final_fields
  late GoRouter _router = GoRouter(
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
                        return PostListScreen();
                      },
                      routes: <RouteBase>[
                        GoRoute(
                            path: 'othersProfile/:id',
                            builder: (context, state) {
                              String id = state.pathParameters["id"]!;
                              return OtherProfileScreen(
                                id: id,
                              );
                            },
                            routes: <RouteBase>[
                              GoRoute(
                                path: 'postDetail/:id',
                                builder: (context, state) {
                                  String id = state.pathParameters["id"]!;
                                  return PostDetailScreen(id: id);
                                },
                              )
                            ]),
                        GoRoute(
                          path: 'comments/:id',
                          builder: (context, state) {
                            String id = state.pathParameters["id"]!;
                            return XtourCommentSection(id: id);
                          },
                        ),
                        GoRoute(
                          path: 'createPost',
                          builder: (context, state) {
                            return PostListScreen();
                          },
                        )
                      ])
                ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                  path: '/search',
                  builder: (context, state) {
                    return SearchScreen();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: 'othersProfile/:id',
                        builder: (context, state) {
                          String id = state.pathParameters["id"]!;
                          return OtherProfileScreen(
                            id: id,
                          );
                        },
                        routes: <RouteBase>[
                          GoRoute(
                            path: 'postDetail/:id',
                            builder: (context, state) {
                              String id = state.pathParameters["id"]!;
                              return PostDetailScreen(id: id);
                            },
                          )
                        ]),
                    GoRoute(
                      path: 'postDetail/:id',
                      builder: (context, state) {
                        String id = state.pathParameters["id"]!;
                        return PostDetailScreen(id: id);
                      },
                    )
                  ])
            ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                  path: '/journal',
                  builder: (context, state) {
                    return JournalListScreen();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: 'othersProfile/:id',
                        builder: (context, state) {
                          String id = state.pathParameters["id"]!;
                          return OtherProfileScreen(
                            id: id,
                          );
                        },
                        routes: <RouteBase>[
                          GoRoute(
                            path: 'postDetail/:id',
                            builder: (context, state) {
                              String id = state.pathParameters["id"]!;
                              return PostDetailScreen(id: id);
                            },
                          )
                        ]),
                    GoRoute(
                      path: 'createJournal',
                      builder: (context, state) {
                        return PostListScreen();
                      },
                    ),
                    GoRoute(
                      path: 'webview',
                      builder: (context, state) {
                        var query = state.queryParameters;
                        String title = query['link']!;

                        return WebViewScreen(title: title);
                      },
                    )
                  ])
            ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                  path: '/profile',
                  builder: (context, state) {
                    return ProfileScreen();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'editProfile',
                      builder: (context, state) {
                        return EditProfileScreen();
                      },
                    ),
                    GoRoute(
                      path: 'postDetail/:id',
                      builder: (context, state) {
                        String id = state.pathParameters["id"]!;
                        return PostDetailScreen(id: id);
                      },
                    ),
                    GoRoute(
                        path: 'pendingPost',
                        builder: (context, state) {
                          return PendingPostListScreen();
                        },
                        routes: <RouteBase>[
                          GoRoute(
                            path: 'editPendingPost/:id',
                            builder: (context, state) {
                              String id = state.pathParameters["id"]!;
                              return EditPendingPostScreen(id: id);
                            },
                          ),
                        ]),
                    GoRoute(
                        path: 'pendingJournal',
                        builder: (context, state) {
                          return PendingJournalListScreen();
                        },
                        routes: <RouteBase>[
                          GoRoute(
                            path: 'editPendingJournal/:id',
                            builder: (context, state) {
                              String id = state.pathParameters["id"]!;
                              return EditPendingJournalScreen(
                                id: id,
                              );
                            },
                          ),
                          GoRoute(
                            path: 'webview',
                            builder: (context, state) {
                              var query = state.queryParameters;
                              String title = query['link']!;
                              return WebViewScreen(title: title);
                            },
                          )
                        ]),
                    GoRoute(
                        path: 'othersProfile/:id',
                        builder: (context, state) {
                          String id = state.pathParameters["id"]!;
                          return OtherProfileScreen(
                            id: id,
                          );
                        },
                        routes: <RouteBase>[
                          GoRoute(
                            path: 'postDetail/:id',
                            builder: (context, state) {
                              String id = state.pathParameters["id"]!;
                              return PostDetailScreen(id: id);
                            },
                          )
                        ]),
                  ])
            ]),
          ]),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return const Signup();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      )
    ],
    // ignore: body_might_complete_normally_nullable
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authBloc.state is AuthAuthenticated;
      final bool initializing = authBloc.state is AuthInitializing;

      final bool loggingIn =
          state.location == '/login' || state.location == "/signup";

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
