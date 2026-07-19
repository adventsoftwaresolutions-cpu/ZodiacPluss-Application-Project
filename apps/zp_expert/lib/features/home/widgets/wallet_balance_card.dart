import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zp_expert/shared/utils/currency_formatter.dart';

import '../data/wallet_repository.dart';

class WalletBalanceCard extends ConsumerWidget {
  const WalletBalanceCard({required this.onCheckStatus, super.key});

  final VoidCallback onCheckStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<double> balance = ref.watch(walletBalanceProvider);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double baseWidth = 360.0;
        final double scale =
            (constraints.maxWidth / baseWidth).clamp(0.85, 1.4);

        final double iconSize = 40 * scale;
        final double spacing12 = 12 * scale;
        final double spacing8 = 8 * scale;
        final double titleFont = 14 * scale;
        final double balanceFont = 23 * scale;
        final double helperFont = 14 * scale;
        final double loaderSize = 26 * scale;
        final double buttonPaddingH = 16 * scale;
        final double buttonPaddingV = 10 * scale;
        final double buttonRadius = 12 * scale;
        final double buttonFont = 14 * scale;

        final Widget balanceDetails = Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/wallet.svg',
              width: iconSize,
              height: iconSize,
            ),
            SizedBox(width: spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Wallet Balance',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: titleFont, color: Colors.black54),
                  ),
                  SizedBox(height: 2 * scale),
                  balance.when(
                    data: (double value) => Text(
                      formatCompactINR(value),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: balanceFont,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    loading: () => SizedBox(
                      height: loaderSize,
                      width: loaderSize,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (Object error, StackTrace stackTrace) => Text(
                      'Unable to load balance',
                      style: TextStyle(color: Colors.red, fontSize: helperFont),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        final Widget statusButton = _PressableButton(
          onPressed: onCheckStatus,
          radius: buttonRadius,
          padding: EdgeInsets.symmetric(
            horizontal: buttonPaddingH,
            vertical: buttonPaddingV,
          ),
          backgroundColor: const Color(0xFFD6E9E7),
          child: Text(
            'Check Status',
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: buttonFont,
            ),
          ),
        );

        if (constraints.maxWidth < 280) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              balanceDetails,
              SizedBox(height: spacing12),
              statusButton,
            ],
          );
        }

        return Row(
          children: <Widget>[
            Expanded(child: balanceDetails),
            SizedBox(width: spacing8),
            statusButton,
          ],
        );
      },
    );
  }
}

class _PressableButton extends StatefulWidget {
  const _PressableButton({
    required this.child,
    required this.onPressed,
    required this.radius,
    required this.padding,
    required this.backgroundColor,
  });

  final Widget child;
  final VoidCallback onPressed;
  final double radius;
  final EdgeInsets padding;
  final Color backgroundColor;

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final double translateY = _pressed ? 2.0 : 0.0;
    final double blur = _pressed ? 4.0 : 10.0;
    final Offset offset = Offset(0, _pressed ? 1 : 4);
    final Color shadowColor =
        Colors.black.withValues(alpha: _pressed ? 0.06 : 0.12);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, translateY, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: blur,
            offset: offset,
          ),
        ],
      ),
      child: Material(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.radius),
          onTap: widget.onPressed,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: Padding(
            padding: widget.padding,
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
