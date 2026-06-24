import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';

class AddFundsSheet extends ConsumerStatefulWidget {
  final GoalEntity goal;

  const AddFundsSheet({super.key, required this.goal});

  @override
  ConsumerState<AddFundsSheet> createState() => _AddFundsSheetState();
}

class _AddFundsSheetState extends ConsumerState<AddFundsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final ok = await ref.read(goalsNotifierProvider.notifier).addFunds(
          widget.goal.id,
          double.parse(_amountCtrl.text),
          _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        );

    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      navigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Funds added!')));
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not add funds.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contribsAsync =
        ref.watch(recentContributionsProvider(widget.goal.id));

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Funds', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 2),
            Text(widget.goal.title, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            // Current savings progress for this goal.
            Container(
              key: const Key('saved-progress'),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Saved so far', style: AppTextStyles.bodySmall),
                      Text(
                        '${formatCurrency(widget.goal.savedAmount)} of ${formatCurrency(widget.goal.targetAmount)}',
                        style: AppTextStyles.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: widget.goal.progressPercent,
                      minHeight: 6,
                      backgroundColor: AppColors.divider,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Amount',
              controller: _amountCtrl,
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
            const SizedBox(height: 16),
            AppTextField(
              label: 'Note (optional)',
              controller: _noteCtrl,
              hint: 'e.g. Part-time paycheck',
            ),
            const SizedBox(height: 20),
            Text('Recent contributions', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            contribsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => Text('Could not load contributions',
                  style: AppTextStyles.bodySmall),
              data: (contribs) {
                if (contribs.isEmpty) {
                  return Text('No contributions yet.',
                      style: AppTextStyles.bodySmall);
                }
                return Column(
                  children: [
                    for (final c in contribs)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.add_circle_outline,
                            color: AppColors.success),
                        title: Text(formatCurrency(c.amount),
                            style: AppTextStyles.titleMedium),
                        subtitle: Text(
                          c.note.isEmpty
                              ? formatDateShort(c.date)
                              : '${c.note} • ${formatDateShort(c.date)}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Save',
              isLoading: _saving,
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
