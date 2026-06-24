import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';

/// Amount display + custom numpad. Entry is in "cents" mode: each digit shifts
/// the value left (e.g. 1, 2, 3 → \$1.23). Calls [onChanged] with dollars.
class AmountInput extends StatefulWidget {
  final double amount;
  final ValueChanged<double> onChanged;

  const AmountInput({
    super.key,
    required this.amount,
    required this.onChanged,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late int _cents = (widget.amount * 100).round();

  static const int _maxCents = 99999999; // \$999,999.99

  void _tapDigit(int d) {
    final next = _cents * 10 + d;
    if (next > _maxCents) return;
    setState(() => _cents = next);
    widget.onChanged(_cents / 100);
  }

  void _backspace() {
    setState(() => _cents ~/= 10);
    widget.onChanged(_cents / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          formatCurrency(_cents / 100),
          key: const Key('amount-display'),
          style: AppTextStyles.amount.copyWith(
            color: Colors.white,
            fontSize: 48,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the keypad to enter an amount',
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
        _Numpad(onDigit: _tapDigit, onBackspace: _backspace),
      ],
    );
  }
}

class _Numpad extends StatelessWidget {
  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;

  const _Numpad({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    return Column(
      children: [
        for (var row = 0; row < 3; row++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var col = 0; col < 3; col++)
                Expanded(child: _key(keys[row * 3 + col])),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(child: SizedBox()),
            Expanded(child: _key('0')),
            Expanded(
              child: InkWell(
                key: const Key('numpad-backspace'),
                onTap: onBackspace,
                child: const SizedBox(
                  height: 56,
                  child: Icon(Icons.backspace_outlined, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _key(String label) {
    return InkWell(
      key: Key('numpad-$label'),
      onTap: () => onDigit(int.parse(label)),
      child: SizedBox(
        height: 56,
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
