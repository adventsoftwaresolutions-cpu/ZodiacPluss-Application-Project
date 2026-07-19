import 'dart:ui';

import 'package:flutter/material.dart';

import '../../themes/app_radius.dart';
import '../../themes/app_spacing.dart';
import 'header_action_buttons.dart';
import 'sidebar_trigger_button.dart';

class GlassTopBar extends StatelessWidget {
  const GlassTopBar({
    required this.onNotificationTap,
    required this.onChatTap,
    super.key,
    this.title,
    this.subtitle,
    this.onSidebarTap,
    this.onBackTap,
    this.showActionButtons = true,
  });

  final String? title;
  final String? subtitle;
  final VoidCallback? onSidebarTap;
  final VoidCallback? onBackTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;
  final bool showActionButtons;

  static const EdgeInsets rootPagePadding = EdgeInsets.fromLTRB(16, 16, 16, 0);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surface = Theme.of(context).colorScheme.surface;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                surface.withValues(alpha: isDark ? 0.22 : 0.28),
                surface.withValues(alpha: isDark ? 0.12 : 0.16),
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.32),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              if (onBackTap != null)
                _GlassBackButton(onTap: onBackTap!)
              else
                SidebarTriggerButton(onTap: onSidebarTap),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _TopBarTitle(title: title, subtitle: subtitle)),
              if (showActionButtons) ...<Widget>[
                const SizedBox(width: AppSpacing.sm),
                HeaderActionButtons(
                  diameter: 40,
                  iconSize: 19,
                  spacing: AppSpacing.sm,
                  onNotificationTap: onNotificationTap,
                  onChatTap: onChatTap,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBarTitle extends StatelessWidget {
  const _TopBarTitle({required this.title, required this.subtitle});

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    if (title == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: 'Back',
        child: Material(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      );
}
