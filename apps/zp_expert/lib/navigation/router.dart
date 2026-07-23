import 'package:flutter/material.dart';
import '../../features/faq/faq.dart';
import '../../features/splash/splash.dart';
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
import '../../features/chat/chat.dart';
import '../../features/chat/chat_conversation.dart';
import '../../features/call_room/call_room.dart';
import '../../features/kundali/kundali.dart';
import '../../features/today_progress/today_progress.dart';

final List<NavItem> expertNavItems = <NavItem>[
  const NavItem(
    artboard: 'Home-CLICK',
    stateMachineName: 'State-machine',
    semanticLabel: 'Home',
  ),
  const NavItem(
    artboard: 'card',
    stateMachineName: 'State Machine 1',
    semanticLabel: 'Wallet',
  ),
  const NavItem(
    artboard: 'TIMER',
    stateMachineName: 'TIMER_Interactivity',
    semanticLabel: 'Session history',
  ),
  const NavItem(
    artboard: 'User-CLICK',
    stateMachineName: 'State-machine',
    semanticLabel: 'Profile',
  ),
];

final GoRouter expertRouter = GoRouter(
  initialLocation: ExpertRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: ExpertRoutes.splash,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashPage(),
    ),
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
      path: ExpertRoutes.chats,
      builder: (BuildContext context, GoRouterState state) =>
          const ChatInboxPage(),
    ),
    GoRoute(
      path: ExpertRoutes.chatConversation,
      builder: (BuildContext context, GoRouterState state) =>
          ChatConversationPage(
        threadId: state.pathParameters['threadId']!,
        promptSessionSummary:
            state.uri.queryParameters['promptSummary'] == 'true',
      ),
    ),
    GoRoute(
      path: ExpertRoutes.callRoom,
      builder: (BuildContext context, GoRouterState state) => CallRoomPage(
        roomId: state.pathParameters['roomId']!,
      ),
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
    GoRoute(
      path: ExpertRoutes.kundali,
      builder: (BuildContext context, GoRouterState state) =>
          const KundaliPage(),
    ),
    GoRoute(
      path: ExpertRoutes.todayProgress,
      builder: (BuildContext context, GoRouterState state) =>
          const TodayProgressPage(),
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
