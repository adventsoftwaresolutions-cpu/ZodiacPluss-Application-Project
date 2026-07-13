// home.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zp_expert/features/home/widgets/availability_schedule_card.dart';
import 'package:zp_expert/features/home/widgets/manage_pricing_card.dart';
import 'package:zp_expert/features/home/widgets/performance_card.dart';
import 'package:zp_expert/features/home/widgets/schedule_card.dart';
import 'package:zp_expert/shared/data/expert_profile.dart';
import 'package:zp_expert/shared/data/expert_profile_repository.dart';
import 'package:zp_expert/startup_timing.dart';
import '../../shared/widgets/gradient_page.dart';
import 'widgets/profile_greeting_header.dart';
import 'widgets/wallet_balance_card.dart';
import 'widgets/availability_toggle_card.dart';
import 'data/availability_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    debugPrint('Home initState: ${stopwatch.elapsedMilliseconds} ms');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('First frame: ${stopwatch.elapsedMilliseconds} ms');
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(availabilityControllerProvider);
    final AsyncValue<ExpertProfile> profileAsync = ref.watch(expertProfileProvider);

    return GradientPage(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                 height: MediaQuery.paddingOf(context).top,
              ),
              profileAsync.when(
                data: (ExpertProfile profile) => ProfileGreetingHeader(
                  name: profile.name,
                  role: profile.role.label,
                  avatarUrl: profile.avatarUrl,
                  isVerified: profile.isVerified,
                  status: status,
                  onNotificationTap: () {},
                  onChatTap: () {},
                ),
                loading: () => const SizedBox(height: 90),
                error: (Object e, StackTrace s) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    WalletBalanceCard(onCheckStatus: () {}),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(height: 1),
                    ),
                    const AvailabilityToggleCard(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ManagePricingCard(
                onTap: () {
                  // TODO: wire to pricing/offers route once that screen exists
                },
              ),
              const SizedBox(height: 12),
              PerformanceCard(
                onSessionHistoryTap: () {
                  // TODO: wire to session history route
                },
                onTransactionHistoryTap: () {
                  // TODO: wire to transaction history route
                },
                onReviewsTap: () {
                  // TODO: wire to reviews route
                },
              ),
              const SizedBox(height: 12),
              const AvailabilityScheduleCard(),
              const SizedBox(height: 12),
              ScheduleCard(
                onViewAllTap: () {
                  // TODO: wire to full schedule/queue route once it exists
                },
              ),
              const SizedBox(height: 44),
            ],
          ),
        ),
      ),
    );
  }
}