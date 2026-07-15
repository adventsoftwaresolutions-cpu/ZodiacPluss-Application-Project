import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/gradient_page.dart';
import 'data/models/pricing_model.dart';
import 'data/provider/pricing_provider.dart';
import 'widgets/loyal_user_note.dart';
import 'widgets/pricing_header.dart';
import 'widgets/pricing_content_skeleton.dart';
import 'widgets/pricing_intro_card.dart';
import 'widgets/pricing_plan_card.dart';

class ManagePricingPage extends ConsumerWidget {
  const ManagePricingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PricingPlan>> pricingAsync =
        ref.watch(pricingProvider);
    return GradientPage(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(children: <Widget>[
            PricingHeader(onBackTap: () => Navigator.of(context).pop()),
            const SizedBox(height: 20),
            Expanded(
              child: pricingAsync.when(
                data: (List<PricingPlan> plans) =>
                    _PricingContent(plans: plans),
                loading: () => const _PricingLoadingContent(),
                error: (Object _, StackTrace __) => Center(
                    child: TextButton(
                        onPressed: () {
                          ref.invalidate(pricingProvider);
                        },
                        child: const Text('Retry',
                            style: TextStyle(color: Colors.white)))),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _PricingContent extends ConsumerWidget {
  const _PricingContent({required this.plans});
  final List<PricingPlan> plans;

  @override
  Widget build(BuildContext context, WidgetRef ref) => TweenAnimationBuilder<
          double>(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: child,
            ),
          ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24))),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const PricingIntroCard(),
                const SizedBox(height: 20),
                const Text('Set Your pricing',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                const Text('Prices are set per minute',
                    style: TextStyle(fontSize: 14, color: Color(0xFF74777A))),
                const SizedBox(height: 10),
                ...plans.expand((PricingPlan plan) => <Widget>[
                      PricingPlanCard(
                          plan: plan,
                          onItemChanged: (PricingService service, int? price,
                                  int? discount) =>
                              ref.read(pricingProvider.notifier).updateItem(
                                  planKind: plan.kind,
                                  service: service,
                                  price: price,
                                  discountPercent: discount)),
                      const SizedBox(height: 16)
                    ]),
                const LoyalUserNote(),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                        onPressed: () async {
                          await ref.read(pricingProvider.notifier).save();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Pricing changes saved locally.')));
                          }
                        },
                        child: const Text('Save Changes',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)))),
              ]),
        ),
      ));
}

class _PricingLoadingContent extends StatelessWidget {
  const _PricingLoadingContent();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const PricingContentSkeleton(),
      );
}
