import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Bottom sheet to set or update the month's total budget limit.
class SetBudgetSheet extends StatefulWidget {
  final double? initialLimit;
  final ValueChanged<double> onSave;

  const SetBudgetSheet({super.key, this.initialLimit, required this.onSave});

  @override
  State<SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends State<SetBudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _limitCtrl = TextEditingController(
    text: (widget.initialLimit ?? 0) > 0
        ? widget.initialLimit!.toStringAsFixed(0)
        : '',
  );

  @override
  void dispose() {
    _limitCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(double.parse(_limitCtrl.text));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.pagePadding,
        right: AppSizes.pagePadding,
        top: AppSizes.pagePadding,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.pagePadding,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Set Monthly Budget', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Choose how much you want to spend this month.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              key: const Key('monthly-limit-field'),
              label: 'Monthly limit',
              controller: _limitCtrl,
              hint: '0.00',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final parsed = double.tryParse(v ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Enter an amount greater than zero';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.lg),
            AppButton(label: 'Save Budget', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
