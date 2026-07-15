class PricingPlan {
  const PricingPlan({
    required this.userType,
    required this.description,
    required this.kind,
    required this.items,
  });

  final PricingUserType userType;
  final String description;
  final PricingPlanKind kind;
  final List<PricingItem> items;

  PricingPlan copyWith({List<PricingItem>? items}) {
    return PricingPlan(
      userType: userType,
      description: description,
      kind: kind,
      items: items ?? this.items,
    );
  }

  factory PricingPlan.fromJson(Map<String, dynamic> json) => PricingPlan(
        userType: PricingUserType.values.byName(json['userType'] as String),
        description: json['description'] as String,
        kind: PricingPlanKind.values.byName(json['kind'] as String),
        items: (json['items'] as List<dynamic>)
            .map((dynamic item) =>
                PricingItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userType': userType.name,
        'description': description,
        'kind': kind.name,
        'items': items.map((PricingItem item) => item.toJson()).toList(),
      };
}

class PricingItem {
  const PricingItem({
    required this.service,
    required this.price,
    required this.discountPercent,
  });

  final PricingService service;
  final int price;
  final int discountPercent;

  int get userPays => price - (price * discountPercent / 100).round();

  PricingItem copyWith({int? price, int? discountPercent}) => PricingItem(
        service: service,
        price: price ?? this.price,
        discountPercent: discountPercent ?? this.discountPercent,
      );

  factory PricingItem.fromJson(Map<String, dynamic> json) => PricingItem(
        service: PricingService.values.byName(json['service'] as String),
        price: json['price'] as int,
        discountPercent: json['discountPercent'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'service': service.name,
        'price': price,
        'discountPercent': discountPercent,
      };
}

enum PricingUserType { normal, loyal }

enum PricingPlanKind { normal, loyal }

enum PricingService {
  chat('Chat'),
  voice('Voice'),
  video('Video');

  const PricingService(this.label);

  final String label;
}
