import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:sharing_map/main.dart';
import 'package:sharing_map/scaffold_with_nav.dart';
import 'package:sharing_map/screens/add_new_item_page.dart';
import 'package:sharing_map/screens/getstarted_screens/get_start.dart';
import 'package:sharing_map/screens/getstarted_screens/intro_screen.dart';
import 'package:sharing_map/screens/home.dart';
import 'package:sharing_map/screens/item_list_page.dart';
import 'package:sharing_map/screens/register_screens/registration_screen.dart';
import 'package:sharing_map/screens/register_screens/reset_screen.dart';
import 'package:sharing_map/test_details_screen.dart';
import 'package:sharing_map/test_root_page.dart';
import 'package:sharing_map/path.dart';

import 'package:sharing_map/screens/register_screens/login_screen.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';

class RouterStart extends StatefulWidget {
  RouterStart({super.key, required this.initLocation});
  final String initLocation;
  @override
  State<RouterStart> createState() => _RouterStartState();
}

class _RouterStartState extends State<RouterStart> {
  GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  GlobalKey<NavigatorState> _registrationKey =
      GlobalKey<NavigatorState>(debugLabel: 'registrasation');
  GlobalKey<NavigatorState> _otherKey =
      GlobalKey<NavigatorState>(debugLabel: 'other');
  GlobalKey<NavigatorState> _thirdKey =
      GlobalKey<NavigatorState>(debugLabel: 'other_other');

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        restorationScopeId: "Test",
        debugShowCheckedModeBanner: false,
        title: "Sharing Map",
        theme: GetAppTheme(),
        routerConfig: GoRouter(
          // navigatorKey: _rootNavigatorKey,
          initialLocation: widget.initLocation,
          routes: <RouteBase>[
            ShellRoute(
                builder: (context, state, child) {
                  return Scaffold(
                    backgroundColor: MColors.dashAmber,
                    // appBar: AppBar(),
                    body: Center(child: child),
                  );
                },
                routes: [
                  GoRoute(
                    path: SMPath.start,
                    builder: (BuildContext context, GoRouterState state) =>
                        IntroScreen(),
                    routes: <RouteBase>[
                      GoRoute(
                        path: SMPath.login,
                        builder: (BuildContext context, GoRouterState state) =>
                            LoginScreen(),
                      ),
                      GoRoute(
                        path: SMPath.registration,
                        builder: (BuildContext context, GoRouterState state) =>
                            RegistrationScreen(),
                      ),
                      GoRoute(
                        path: SMPath.forgetPassword,
                        builder: (BuildContext context, GoRouterState state) =>
                            ResetScreen(),
                      ),
                    ],
                  ),
                ]),
            StatefulShellRoute.indexedStack(
              builder: (BuildContext context, GoRouterState state,
                  StatefulNavigationShell navigationShell) {
                return ScaffoldWithNavBar(navigationShell: navigationShell);
              },
              branches: <StatefulShellBranch>[
                StatefulShellBranch(
                  navigatorKey: _thirdKey,
                  routes: <RouteBase>[
                    GoRoute(
                      path: SMPath.home,
                      builder: (BuildContext context, GoRouterState state) =>
                          ItemListPage(),
                      routes: <RouteBase>[
                        GoRoute(
                          path: 'details/:param',
                          builder:
                              (BuildContext context, GoRouterState state) =>
                                  DetailsScreen(
                            label: 'B',
                            param: state.pathParameters['param'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: <RouteBase>[
                    GoRoute(
                      path: SMPath.favorite,
                      builder: (BuildContext context, GoRouterState state) =>
                          AddNewItemPage(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: <RouteBase>[
                    GoRoute(
                      path: SMPath.addItem,
                      builder: (BuildContext context, GoRouterState state) =>
                          AddNewItemPage(),
                    ),
                  ],
                ),
                // The route branch for the third tab of the bottom navigation bar.
                // StatefulShellBranch(
                //   routes: <RouteBase>[
                //     GoRoute(
                //       // The screen to display as the root in the third tab of the
                //       // bottom navigation bar.
                //       path: '/c',
                //       builder: (BuildContext context, GoRouterState state) =>
                //           const RootScreen(
                //         label: 'C',
                //         detailsPath: '/c/details',
                //       ),
                //       routes: <RouteBase>[
                //         GoRoute(
                //           path: 'details',
                //           builder: (BuildContext context, GoRouterState state) =>
                //               DetailsScreen(
                //             label: 'C',
                //             extra: state.extra,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ));
  }
}
