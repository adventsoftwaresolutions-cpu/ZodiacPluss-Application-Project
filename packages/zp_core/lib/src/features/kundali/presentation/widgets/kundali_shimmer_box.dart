import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KundaliShimmerBox extends StatelessWidget {
  const KundaliShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: Color.alphaBlend(
        colors.onSurface.withValues(alpha: 0.12),
        colors.surface,
      ),
      highlightColor: Color.alphaBlend(
        colors.onSurface.withValues(alpha: 0.04),
        colors.surface,
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
