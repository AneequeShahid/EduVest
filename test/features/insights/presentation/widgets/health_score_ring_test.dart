import 'dart:math' as math;

import 'package:eduvest_output/features/insights/presentation/widgets/health_score_ring.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  HealthScoreRingPainter painterForScore(int score) =>
      HealthScoreRingPainter(progress: score / 100.0);

  test('1. arc is proportional to score (score/100 * 2π)', () {
    for (final s in [10, 33, 50, 75]) {
      final painter = painterForScore(s);
      expect(painter.sweepAngle, closeTo(s / 100 * 2 * math.pi, 1e-9));
    }
  });

  test('2. score 100 → full circle (2π)', () {
    expect(painterForScore(100).sweepAngle, closeTo(2 * math.pi, 1e-9));
  });

  test('3. score 0 → no arc', () {
    expect(painterForScore(0).sweepAngle, 0);
  });

  test('4. score 82 → arc at 82% of a full circle', () {
    final painter = painterForScore(82);
    expect(painter.sweepAngle, closeTo(0.82 * 2 * math.pi, 1e-9));
  });
}
