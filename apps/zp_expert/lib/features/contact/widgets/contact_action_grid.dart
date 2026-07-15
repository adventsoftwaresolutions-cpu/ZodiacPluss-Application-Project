import 'package:flutter/material.dart';

import '../data/contact_model.dart';
import 'contact_action_card.dart';

class ContactActionGrid extends StatelessWidget {
  final List<ContactAction> actions;
  final ValueChanged<ContactAction> onActionTap;

  const ContactActionGrid({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (context, index) {
        return ContactActionCard(
          action: actions[index],
          onTap: actions[index].destination == null
              ? null
              : () => onActionTap(actions[index]),
        );
      },
    );
  }
}
