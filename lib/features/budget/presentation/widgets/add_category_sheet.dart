import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/category_icon.dart';
import '../../domain/entities/budget_category_entity.dart';

/// Bottom sheet for creating a budget category (name, limit, icon, color).
class AddCategorySheet extends StatefulWidget {
  final ValueChanged<BudgetCategoryEntity> onSave;

  const AddCategorySheet({super.key, required this.onSave});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();

  static const _icons = [
    'Education', 'Rent', 'Groceries', 'Transport', 'Fun', 'Health', 'Others',
  ];
  static const _colors = [
    '#C1622A', '#2E7D32', '#1565C0', '#7B5EA7', '#D81B60', '#F9A825',
  ];

  String _icon = 'Others';
  String _color = '#C1622A';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _limitCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(
      BudgetCategoryEntity(
        id: '',
        name: _nameCtrl.text.trim(),
        limit: double.parse(_limitCtrl.text),
        icon: _icon,
        color: _color,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
            Text('New Category', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Name',
              controller: _nameCtrl,
              hint: 'e.g. Subscriptions',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
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
            const SizedBox(height: 16),
            Text('Icon', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: [
                for (final name in _icons)
                  GestureDetector(
                    key: Key('icon-option-$name'),
                    onTap: () => setState(() => _icon = name),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _icon == name
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _icon == name
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Icon(CategoryIcon.iconForCategory(name), size: 22),
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
                    key: Key('color-option-$hex'),
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
            const SizedBox(height: 24),
            AppButton(label: 'Add Category', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
