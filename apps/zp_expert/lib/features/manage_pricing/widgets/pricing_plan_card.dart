import 'package:flutter/material.dart';

import '../data/models/pricing_model.dart';

class PricingPlanCard extends StatelessWidget {
  const PricingPlanCard({
    required this.plan,
    required this.onItemChanged,
    super.key,
  });

  final PricingPlan plan;
  final void Function(PricingService service, int? price, int? discount)
      onItemChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF76C5D0)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFD5F3F4),
                  child: Icon(
                    plan.kind == PricingPlanKind.normal
                        ? Icons.person_outline_rounded
                        : Icons.workspace_premium_outlined,
                    color: const Color(0xFF007D88),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          '${plan.userType == PricingUserType.normal ? 'Normal' : 'Loyal'} User',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      Text(plan.description,
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF74777A))),
                    ],
                  ),
                ),
                if (plan.kind == PricingPlanKind.normal)
                  const Tooltip(
                      message: 'Price range depends on level',
                      child: Icon(Icons.info_outline,
                          color: Color(0xFF657579), size: 20)),
              ],
            ),
            const SizedBox(height: 12),
            ...plan.items.map((PricingItem item) => _PricingRow(
                item: item,
                onChanged: (int? price, int? discount) =>
                    onItemChanged(item.service, price, discount))),
          ],
        ),
      );
}

class _PricingRow extends StatelessWidget {
  const _PricingRow({required this.item, required this.onChanged});

  final PricingItem item;
  final void Function(int? price, int? discount) onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.service.label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget priceField = _LabelledField(
                  label: 'Price per minute',
                  child: _PriceControl(
                    value: item.price,
                    onChanged: (int value) => onChanged(value, null),
                  ),
                );
                final Widget discountField = _LabelledField(
                  label: 'Discount offer',
                  child: _DiscountControl(
                    value: item.discountPercent,
                    onChanged: (int value) => onChanged(null, value),
                  ),
                );

                if (constraints.maxWidth < 280) {
                  return Column(
                    children: <Widget>[
                      priceField,
                      const SizedBox(height: 10),
                      discountField,
                    ],
                  );
                }

                return Row(
                  children: <Widget>[
                    Expanded(child: priceField),
                    const SizedBox(width: 12),
                    Expanded(child: discountField),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 3),
              child: Text('They pay: ₹${item.userPays}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF588C16))),
            ),
          ],
        ),
      );
}

class _LabelledField extends StatelessWidget {
  const _LabelledField({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(label,
            style: const TextStyle(
                color: Color(0xFF657579),
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        child
      ]);
}

class _PriceControl extends StatelessWidget {
  const _PriceControl({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
        height: 44,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD6D8DC)),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: <Widget>[
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('₹',
                  style: TextStyle(fontSize: 22, color: Color(0xFF008A98)))),
          Expanded(
              child: Center(
                  child: Text('$value',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)))),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () => onChanged(value + 5),
                    child: const Icon(Icons.arrow_drop_up, size: 20)),
                InkWell(
                    onTap: value > 5 ? () => onChanged(value - 5) : null,
                    child: const Icon(Icons.arrow_drop_down, size: 20))
              ])
        ]),
      );
}

class _DiscountControl extends StatelessWidget {
  const _DiscountControl({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
        height: 44,
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD6D8DC)),
            borderRadius: BorderRadius.circular(8)),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
                isExpanded: true,
                isDense: true,
                value: value,
                icon: const Icon(Icons.arrow_drop_down),
                items: <int>[0, 10, 20, 30, 40, 50]
                    .map((int discount) => DropdownMenuItem<int>(
                        value: discount,
                        child: Row(children: <Widget>[
                          const Icon(Icons.local_offer_outlined,
                              color: Color(0xFF008A98), size: 19),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              discount == 0 ? 'No offer' : '$discount% off',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ])))
                    .toList(),
                onChanged: (int? discount) {
                  if (discount != null) onChanged(discount);
                })),
      );
}
