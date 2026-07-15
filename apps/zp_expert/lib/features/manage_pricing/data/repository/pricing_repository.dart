import '../models/pricing_model.dart';

abstract class PricingRepository {
  Future<List<PricingPlan>> fetchPlans();

  Future<void> savePlans(List<PricingPlan> plans);
}

class StubPricingRepository implements PricingRepository {
  static List<PricingPlan> _plans = <PricingPlan>[
    const PricingPlan(
      userType: PricingUserType.normal,
      description: 'For all new and regular users',
      kind: PricingPlanKind.normal,
      items: <PricingItem>[
        PricingItem(
            service: PricingService.chat, price: 80, discountPercent: 10),
        PricingItem(
            service: PricingService.voice, price: 80, discountPercent: 10),
        PricingItem(
            service: PricingService.video, price: 80, discountPercent: 10),
      ],
    ),
    const PricingPlan(
      userType: PricingUserType.loyal,
      description: 'Special pricing for your loyal users',
      kind: PricingPlanKind.loyal,
      items: <PricingItem>[
        PricingItem(
            service: PricingService.chat, price: 60, discountPercent: 50),
        PricingItem(
            service: PricingService.voice, price: 80, discountPercent: 10),
        PricingItem(
            service: PricingService.video, price: 80, discountPercent: 10),
      ],
    ),
  ];

  @override
  Future<List<PricingPlan>> fetchPlans() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _plans;
  }

  @override
  Future<void> savePlans(List<PricingPlan> plans) async {
    _plans = plans;
  }
}
