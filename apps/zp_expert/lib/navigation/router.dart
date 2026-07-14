import 'package:flutter/material.dart';
import '../../features/faq/faq.dart';
import '../../features/verification_pending/verification_pending.dart';
import '../../features/auth/auth.dart';
import '../../features/max_attempt_exhausted/max_attempt_exhausted.dart';
import '../../features/verification_failed/verification_failed.dart';
import '../../features/verification_complete/verification_complete.dart';
import '../../features/verification/verification.dart';
import 'package:go_router/go_router.dart';

import 'navigation_scaffold.dart';
import '../../shared/widgets/nav_item.dart';

import '../../features/home/home.dart';
import '../../features/wallet/wallet.dart';
import '../../features/session/session.dart';
import '../../features/profile/profile.dart';
import '../../features/support/support.dart';
import '../../features/contact/contact.dart';
import '../../features/clients/clients.dart';

final List<NavItem> expertNavItems = <NavItem>[
  const NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home),
  const NavItem(
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet),
  const NavItem(
      icon: Icons.history_rounded, selectedIcon: Icons.history_rounded),
  const NavItem(icon: Icons.person_outline, selectedIcon: Icons.person),
];

final GoRouter expertRouter = GoRouter(
  initialLocation: '/ticket-status',
  routes: <RouteBase>[
    GoRoute(
      path: '/raise-ticket',
      builder: (BuildContext context, GoRouterState state) =>
          const RaiseTicketPage(),
    ),
    GoRoute(
      path: '/ticket-status',
      builder: (BuildContext context, GoRouterState state) =>
          const TicketStatusPage(),
    ),
    GoRoute(
      path: '/contact',
      builder: (BuildContext context, GoRouterState state) =>
          const ContactPage(),
      path: '/clients',
      builder: (BuildContext context, GoRouterState state) =>
          const ClientsPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell shell) {
        return NavigationScaffold(
            navigationShell: shell, items: expertNavItems);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/home',
              builder: (BuildContext c, GoRouterState s) => const HomePage()),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/wallet',
              builder: (BuildContext c, GoRouterState s) => const WalletPage()),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/session',
              builder: (BuildContext c, GoRouterState s) =>
                  const SessionScreen()),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/profile',
              builder: (BuildContext c, GoRouterState s) =>
                  const ProfileScreen()),
        ]),
      ],
    ),
    GoRoute(
      path: '/faq',
      builder: (BuildContext c, GoRouterState s) => const FaqPage(),
    ),
    GoRoute(
      path: '/auth',
      builder: (BuildContext c, GoRouterState s) => const AuthPage(),
    ),
    GoRoute(
      path: '/verification',
      builder: (BuildContext c, GoRouterState s) => const VerificationPage(),
    ),
    GoRoute(
      path: '/verification-pending',
      builder: (BuildContext c, GoRouterState s) =>
          const VerificationPendingPage(),
    ),
    GoRoute(
      path: '/verification-complete',
      builder: (BuildContext c, GoRouterState s) =>
          const VerificationCompletePage(),
    ),
    GoRoute(
      path: '/verification-failed',
      builder: (context, state) => const VerificationFailedPage(),
    ),
    GoRoute(
      path: '/max-attempt',
      builder: (context, state) => const MaxAttemptExhaustedPage(),
    ),
  ],
);
