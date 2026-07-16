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
import 'app_routes.dart';
import '../../shared/widgets/nav_item.dart';

import '../../features/home/home.dart';
import '../../features/wallet/wallet.dart';
import '../../features/session/session.dart';
import '../../features/session/session_info.dart';
import '../../features/profile/profile.dart';
import '../../features/support/support.dart';
import '../../features/contact/contact.dart';
import '../../features/clients/clients.dart';
import '../../features/clients/client_history.dart';
import '../../features/manage_pricing/manage_pricing.dart';
import '../../features/reviews/reviews.dart';

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
  initialLocation: '/auth',
  routes: <RouteBase>[
    GoRoute(
      path: ExpertRoutes.managePricing,
      builder: (BuildContext context, GoRouterState state) =>
          const ManagePricingPage(),
    ),
    GoRoute(
      path: ExpertRoutes.reviews,
      builder: (BuildContext context, GoRouterState state) =>
          const ReviewsPage(),
    ),
    GoRoute(
      path: ExpertRoutes.sessionInfo,
      builder: (BuildContext context, GoRouterState state) => SessionInfoScreen(
        sessionId: state.pathParameters['sessionId']!,
      ),
    ),
    GoRoute(
      path: ExpertRoutes.raiseTicket,
      builder: (BuildContext context, GoRouterState state) =>
          const RaiseTicketPage(),
    ),
    GoRoute(
      path: ExpertRoutes.ticketStatus,
      builder: (BuildContext context, GoRouterState state) =>
          const TicketStatusPage(),
    ),
    GoRoute(
      path: ExpertRoutes.contact,
      builder: (BuildContext context, GoRouterState state) =>
          const ContactPage(),
    ),
    GoRoute(
      path: ExpertRoutes.clientHistory,
      builder: (BuildContext context, GoRouterState state) => ClientHistoryPage(
        clientId: state.pathParameters['clientId']!,
      ),
    ),
    GoRoute(
      path: ExpertRoutes.clients,
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
              path: ExpertRoutes.home,
              builder: (BuildContext c, GoRouterState s) => const HomePage()),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: ExpertRoutes.wallet,
              builder: (BuildContext c, GoRouterState s) => const WalletPage()),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: ExpertRoutes.sessionHistory,
              builder: (BuildContext c, GoRouterState s) =>
                  const SessionScreen()),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: ExpertRoutes.profile,
              builder: (BuildContext c, GoRouterState s) =>
                  const ProfileScreen()),
        ]),
      ],
    ),
    GoRoute(
      path: ExpertRoutes.faq,
      builder: (BuildContext c, GoRouterState s) => const FaqPage(),
    ),
    GoRoute(
      path: ExpertRoutes.auth,
      builder: (BuildContext c, GoRouterState s) => const AuthPage(),
    ),
    GoRoute(
      path: ExpertRoutes.verification,
      builder: (BuildContext c, GoRouterState s) => const VerificationPage(),
    ),
    GoRoute(
      path: ExpertRoutes.verificationPending,
      builder: (BuildContext c, GoRouterState s) =>
          const VerificationPendingPage(),
    ),
    GoRoute(
      path: ExpertRoutes.verificationComplete,
      builder: (BuildContext c, GoRouterState s) =>
          const VerificationCompletePage(),
    ),
    GoRoute(
      path: ExpertRoutes.verificationFailed,
      builder: (context, state) => const VerificationFailedPage(),
    ),
    GoRoute(
      path: ExpertRoutes.maxAttempts,
      builder: (context, state) => const MaxAttemptExhaustedPage(),
    ),
  ],
);
