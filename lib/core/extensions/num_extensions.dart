extension NumExtensions on num {
  String get asCurrency => '\$${toStringAsFixed(2)}';

  String get asCompactCurrency {
    if (this >= 1000000) return '\$${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '\$${(this / 1000).toStringAsFixed(1)}K';
    return '\$${toStringAsFixed(2)}';
  }

  String get asPercent => '${toStringAsFixed(1)}%';

  double clampTo(double min, double max) =>
      clamp(min, max).toDouble();
}

extension DoubleExtensions on double {
  double get asBudgetProgress => clamp(0.0, 1.0).toDouble();
}
