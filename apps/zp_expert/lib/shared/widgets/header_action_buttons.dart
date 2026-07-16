import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderActionButtons extends StatelessWidget {
  const HeaderActionButtons({
    required this.onNotificationTap,
    required this.onChatTap,
    super.key,
    this.diameter = 35,
    this.iconSize = 18,
    this.spacing = 10,
    this.direction = Axis.horizontal,
  });

  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;
  final double diameter;
  final double iconSize;
  final double spacing;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ActionIconButton(
          assetPath: 'assets/icons/notification.svg',
          diameter: diameter,
          iconSize: iconSize,
          onTap: onNotificationTap,
        ),
        SizedBox(
          width: direction == Axis.horizontal ? spacing : 0,
          height: direction == Axis.vertical ? spacing : 0,
        ),
        _ActionIconButton(
          assetPath: 'assets/icons/chat.svg',
          diameter: diameter,
          iconSize: iconSize,
          onTap: onChatTap,
        ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.assetPath,
    required this.diameter,
    required this.iconSize,
    required this.onTap,
  });

  final String assetPath;
  final double diameter;
  final double iconSize;
  final VoidCallback onTap;

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
          width: diameter,
          height: diameter,
          child: Center(
            child: SvgPicture.asset(
              assetPath,
              width: iconSize,
              height: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
