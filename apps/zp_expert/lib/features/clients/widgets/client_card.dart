import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/models/client_model.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    required this.client,
    super.key,
    this.onTap,
  });

  final ClientModel client;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      elevation: 1,
      shadowColor: const Color(0x12007D88),
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 31,
                backgroundImage: AssetImage(client.avatarAsset),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      client.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ticketText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _ClientDetail(
                        icon: Icons.phone_outlined, text: client.phoneNumber),
                    const SizedBox(height: 3),
                    _ClientDetail(
                      icon: Icons.access_time_rounded,
                      text: client.sessionLabel,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientDetail extends StatelessWidget {
  const _ClientDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.black45, size: 15),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black45, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
