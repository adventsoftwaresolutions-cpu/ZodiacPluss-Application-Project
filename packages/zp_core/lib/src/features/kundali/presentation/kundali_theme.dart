import 'package:flutter/material.dart';

@immutable
class KundaliThemeData extends ThemeExtension<KundaliThemeData> {
  const KundaliThemeData({
    this.contentBackgroundColor,
    this.successColor,
  });

  final Color? contentBackgroundColor;
  final Color? successColor;

  static KundaliThemeData resolve(BuildContext context) {
    final extension = Theme.of(context).extension<KundaliThemeData>();
    final colors = Theme.of(context).colorScheme;
    return KundaliThemeData(
      contentBackgroundColor:
          extension?.contentBackgroundColor ?? colors.secondary,
      successColor: extension?.successColor ?? const Color(0xFF2E9D68),
    );
  }

  @override
  KundaliThemeData copyWith({
    Color? contentBackgroundColor,
    Color? successColor,
  }) {
    return KundaliThemeData(
      contentBackgroundColor:
          contentBackgroundColor ?? this.contentBackgroundColor,
      successColor: successColor ?? this.successColor,
    );
  }

  @override
  KundaliThemeData lerp(
    covariant ThemeExtension<KundaliThemeData>? other,
    double t,
  ) {
    if (other is! KundaliThemeData) return this;
    return KundaliThemeData(
      contentBackgroundColor: Color.lerp(
        contentBackgroundColor,
        other.contentBackgroundColor,
        t,
      ),
      successColor: Color.lerp(successColor, other.successColor, t),
    );
  }
}
