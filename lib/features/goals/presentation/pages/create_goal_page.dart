import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';
import '../widgets/goal_card.dart';

class CreateGoalPage extends ConsumerStatefulWidget {
  const CreateGoalPage({super.key});

  @override
  ConsumerState<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends ConsumerState<CreateGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  DateTime _targetDate = DateTime.now().add(const Duration(days: 90));
  String _category = 'Other';
  String _emoji = '🎯';
  String _color = '#C1622A';
  bool _saving = false;

  static const _categories = [
    'Laptop', 'Travel', 'Education', 'Emergency', 'Other',
  ];
  static const _emojis = [
    '🎯', '💻', '✈️', '🎓', '🚨', '🏠', '🚗', '📱', '🎸', '📷',
    '💍', '🏝️', '🎮', '👟', '⌚', '🚲', '🛏️', '🎁', '💰', '🌟',
  ];
  static const _colors = [
    '#C1622A', '#7B5EA7', '#1565C0', '#2E7D32', '#D81B60', '#F9A825',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  GoalEntity _previewGoal() => GoalEntity(
        id: 'preview',
        title: _titleCtrl.text.trim().isEmpty
            ? 'Your goal'
            : _titleCtrl.text.trim(),
        targetAmount: double.tryParse(_amountCtrl.text) ?? 0,
        savedAmount: 0,
        targetDate: _targetDate,
        category: _category,
        emoji: _emoji,
        colorHex: _color,
      );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await ref.read(goalsNotifierProvider.notifier).createGoal(
          GoalEntity(
            id: '',
            title: _titleCtrl.text.trim(),
            targetAmount: double.parse(_amountCtrl.text),
            savedAmount: 0,
            targetDate: _targetDate,
            category: _category,
            emoji: _emoji,
            colorHex: _color,
          ),
        );

    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(RouteNames.goals);
      }
      messenger.showSnackBar(const SnackBar(content: Text('Goal created!')));
    } else {
      final err = ref.read(goalsNotifierProvider) ?? 'Could not create goal.';
      messenger.showSnackBar(
        SnackBar(content: Text(err), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New Goal'),
        leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(RouteNames.goals)),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Live preview.
                GoalCard(
                    goal: _previewGoal(), isSelected: false, onTap: () {}),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Goal title',
                  controller: _titleCtrl,
                  hint: 'e.g. New MacBook',
                  onChanged: (_) => setState(() {}),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Target amount',
                  controller: _amountCtrl,
                  hint: '0.00',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    final parsed = double.tryParse(v ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Enter an amount greater than zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text('Target date', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 18),
                        const SizedBox(width: 10),
                        Text(formatDate(_targetDate),
                            style: AppTextStyles.bodyLarge),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Category', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final c in _categories)
                      ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Emoji', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final e in _emojis)
                      GestureDetector(
                        onTap: () => setState(() => _emoji = e),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _emoji == e
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(e, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Color', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: [
                    for (final hex in _colors)
                      GestureDetector(
                        onTap: () => setState(() => _color = hex),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(
                                int.parse('FF${hex.substring(1)}', radix: 16)),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _color == hex
                                  ? AppColors.textPrimary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: 'Create Goal',
                  isLoading: _saving,
                  onPressed: _saving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
