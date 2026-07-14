import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';

class TicketQuickHelp extends StatelessWidget {
  const TicketQuickHelp({
    required this.onFaqTap,
    required this.onContactTap,
    required this.onRaiseTicketTap,
    super.key,
  });

  final VoidCallback onFaqTap;
  final VoidCallback onContactTap;
  final VoidCallback onRaiseTicketTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Quick Help',
            style: TextStyle(
              color: AppColors.ticketText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _QuickHelpCard(
                  animationDelay: 0,
                  assetPath: AppAssets.questionMarkIcon,
                  title: 'FAQ’s',
                  subtitle: 'Find answers to your common question',
                  onTap: onFaqTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickHelpCard(
                  animationDelay: 70,
                  assetPath: AppAssets.contactIcon,
                  usePrimaryIconColor: true,
                  title: 'Contact us',
                  subtitle: 'Connect with our support team',
                  onTap: onContactTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickHelpCard(
                  animationDelay: 140,
                  assetPath: AppAssets.ticketIcon,
                  title: 'Raise a ticket',
                  subtitle: 'Create a new support request',
                  onTap: onRaiseTicketTap,
                ),
              ),
            ],
          ),
        ],
      );
}

class _QuickHelpCard extends StatefulWidget {
  const _QuickHelpCard({
    required this.animationDelay,
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.usePrimaryIconColor = false,
  });

  final int animationDelay;
  final String assetPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool usePrimaryIconColor;

  @override
  State<_QuickHelpCard> createState() => _QuickHelpCardState();
}

class _QuickHelpCardState extends State<_QuickHelpCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 320 + widget.animationDelay),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(begin: 0, end: 1),
        builder: (BuildContext context, double value, Widget? child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        ),
        child: AnimatedScale(
          scale: _isPressed ? .96 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              onTap: widget.onTap,
              onHighlightChanged: (bool isPressed) {
                setState(() => _isPressed = isPressed);
              },
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 157,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      AppColors.white.withValues(alpha: .97),
                      AppColors.ticketField.withValues(alpha: .88),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: .9),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: _isPressed ? .16 : .09,
                      ),
                      blurRadius: _isPressed ? 8 : 14,
                      offset: Offset(0, _isPressed ? 3 : 7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 42,
                        width: 42,
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: .72),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          widget.assetPath,
                          colorFilter: widget.usePrimaryIconColor
                              ? const ColorFilter.mode(
                                  AppColors.primary,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Expanded(
                        child: Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 10,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: _ArrowCircle(isPressed: _isPressed),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _ArrowCircle extends StatelessWidget {
  const _ArrowCircle({this.isPressed = false});

  final bool isPressed;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: isPressed ? AppColors.primary : AppColors.white,
          shape: BoxShape.circle,
        ),
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 160),
          turns: isPressed ? .04 : 0,
          child: Icon(
            Icons.chevron_right_rounded,
            color: isPressed ? AppColors.white : AppColors.primary,
            size: 24,
          ),
        ),
      );
}
