import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../domain/entities/monthly_flow_entity.dart';

class CapitalFlowChart extends StatefulWidget {
  final List<MonthlyFlowEntity> flow;

  const CapitalFlowChart({super.key, required this.flow});

  @override
  State<CapitalFlowChart> createState() => _CapitalFlowChartState();
}

class _CapitalFlowChartState extends State<CapitalFlowChart> {
  bool _monthView = true;

  static const _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Month view → per-month spend. Year view → spend aggregated by year.
  List<({String label, double value})> get _data {
    if (_monthView) {
      return widget.flow
          .map((f) => (label: _monthAbbr[f.month - 1], value: f.totalSpent))
          .toList();
    }
    final byYear = <int, double>{};
    for (final f in widget.flow) {
      byYear[f.year] = (byYear[f.year] ?? 0) + f.totalSpent;
    }
    final years = byYear.keys.toList()..sort();
    return years
        .map((y) => (label: "'${y % 100}", value: byYear[y]!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final maxY = data.isEmpty
        ? 100.0
        : (data.map((d) => d.value).reduce((a, b) => a > b ? a : b) * 1.2)
            .clamp(1.0, double.infinity);
    final activeIndex = _monthView ? data.length - 1 : data.length - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SPENDING TREND',
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Capital Flow', style: AppTextStyles.displayMedium),
              Row(
                children: [
                  _toggle('Month', _monthView, () {
                    setState(() => _monthView = true);
                  }, const Key('toggle-month')),
                  const SizedBox(width: 8),
                  _toggle('Year', !_monthView, () {
                    setState(() => _monthView = false);
                  }, const Key('toggle-year')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                      formatCurrency(rod.toY),
                      const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final i = value.toInt();
                        if (i < 0 || i >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(data[i].label,
                              style: AppTextStyles.bodySmall),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (var i = 0; i < data.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[i].value,
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: i == activeIndex
                              ? AppColors.primary
                              : AppColors.surfaceSecondary,
                        ),
                      ],
                    ),
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(String label, bool active, VoidCallback onTap, Key key) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
