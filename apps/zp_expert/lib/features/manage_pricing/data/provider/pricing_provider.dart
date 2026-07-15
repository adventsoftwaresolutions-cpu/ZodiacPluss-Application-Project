import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pricing_model.dart';
import '../repository/pricing_repository.dart';

final pricingRepositoryProvider = Provider<PricingRepository>(
  (Ref ref) => StubPricingRepository(),
);

final pricingProvider =
    AsyncNotifierProvider<PricingNotifier, List<PricingPlan>>(
        PricingNotifier.new);

class PricingNotifier extends AsyncNotifier<List<PricingPlan>> {
  @override
  Future<List<PricingPlan>> build() =>
      ref.read(pricingRepositoryProvider).fetchPlans();

  void updateItem({
    required PricingPlanKind planKind,
    required PricingService service,
    int? price,
    int? discountPercent,
  }) {
    final List<PricingPlan>? plans = state.value;
    if (plans == null) return;
    state = AsyncData(
      plans.map((PricingPlan plan) {
        if (plan.kind != planKind) return plan;
        return plan.copyWith(
          items: plan.items.map((PricingItem item) {
            if (item.service != service) return item;
            return item.copyWith(
                price: price, discountPercent: discountPercent);
          }).toList(),
        );
      }).toList(),
    );
  }

  Future<void> save() async {
    final List<PricingPlan>? plans = state.value;
    if (plans == null) return;
    await ref.read(pricingRepositoryProvider).savePlans(plans);
  }
}
