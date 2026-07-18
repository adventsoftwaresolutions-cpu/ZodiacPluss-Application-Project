import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FaqHeader extends StatelessWidget {
  const FaqHeader({
    required this.onBackTap,
    required this.onNotificationTap,
    required this.onChatTap,
    super.key,
  });

  final VoidCallback onBackTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _CircleIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: onBackTap,
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'FAQ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Find all your questions',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        _SvgCircleButton(
          assetPath: 'assets/icons/notification.svg',
          onTap: onNotificationTap,
        ),
        const SizedBox(width: 10),
        _SvgCircleButton(
          assetPath: 'assets/icons/chat.svg',
          onTap: onChatTap,
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  static const double _size = 40;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: _size,
          height: _size,
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _SvgCircleButton extends StatelessWidget {
  const _SvgCircleButton({
    required this.assetPath,
    required this.onTap,
  });

  final String assetPath;
  final VoidCallback onTap;

  static const double _size = 40;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: _size,
          height: _size,
          child: Center(
            child: SvgPicture.asset(
              assetPath,
              width: 18,
              height: 18,
            ),
          ),
        ),
      ),
    );
  }
}
