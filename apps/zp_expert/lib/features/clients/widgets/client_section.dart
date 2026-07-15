import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/models/client_model.dart';
import 'client_card.dart';

class ClientSection extends StatelessWidget {
  const ClientSection({
    required this.title,
    required this.subtitle,
    required this.clients,
    required this.isExpanded,
    super.key,
    this.onViewAllTap,
    this.onClientTap,
  });

  final String title;
  final String subtitle;
  final List<ClientModel> clients;
  final bool isExpanded;
  final VoidCallback? onViewAllTap;
  final ValueChanged<ClientModel>? onClientTap;

  @override
  Widget build(BuildContext context) {
    const int previewCount = 3;
    final List<ClientModel> visibleClients = isExpanded
        ? clients
        : clients.take(previewCount).toList(growable: false);
    final bool canExpand = clients.length > previewCount;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: .10)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x10007D88),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.ticketText,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(color: Colors.black45, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (canExpand)
                TextButton.icon(
                  onPressed: onViewAllTap,
                  iconAlignment: IconAlignment.end,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withValues(alpha: .08),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    shape: const StadiumBorder(),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.chevron_right_rounded,
                    size: 18,
                  ),
                  label: Text(
                    isExpanded ? 'Show less' : 'View all',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (visibleClients.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Text('No matching clients',
                  style: TextStyle(color: Colors.black45)),
            )
          else
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Column(
                children: visibleClients
                    .map(
                      (client) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ClientCard(
                          client: client,
                          onTap: onClientTap == null
                              ? null
                              : () => onClientTap!(client),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
        ],
      ),
    );
  }
}
