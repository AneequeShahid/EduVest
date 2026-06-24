import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/expense_entity.dart';
import '../providers/expense_provider.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_picker.dart';
import '../widgets/receipt_picker.dart';
import '../widgets/receipt_uploader.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  final ExpenseEntity? existing;
  final ReceiptPicker? picker;

  const AddExpensePage({super.key, this.existing, this.picker});

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  late final ReceiptPicker _picker =
      widget.picker ?? ImagePickerReceiptPicker();

  double _amount = 0;
  String? _category;
  DateTime _date = DateTime.now();
  bool _isIncome = false;
  File? _receiptFile;

  String? _amountError;
  String? _categoryError;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _amount = e.amount;
      _descCtrl.text = e.description;
      _category = e.category;
      _date = e.date;
      _isIncome = e.isIncome;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _openReceiptSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: const Text('Document'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final file = await _picker.pick(source);
    if (file != null && mounted) setState(() => _receiptFile = file);
  }

  Future<void> _save() async {
    final descValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _amountError =
          _amount <= 0 ? 'Amount must be greater than zero' : null;
      _categoryError = _category == null ? 'Please select a category' : null;
    });
    if (!descValid || _amountError != null || _categoryError != null) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);

    final entity = ExpenseEntity(
      id: widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      amount: _amount,
      description: _descCtrl.text.trim(),
      category: _category!,
      date: _date,
      month: _date.month,
      year: _date.year,
      isIncome: _isIncome,
      receiptUrl: widget.existing?.receiptUrl,
      createdAt: widget.existing?.createdAt,
    );

    final controller = ref.read(expenseControllerProvider.notifier);
    final ok = _isEdit
        ? await controller.updateExpense(entity, receipt: _receiptFile)
        : await controller.addExpense(entity, receipt: _receiptFile);

    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(RouteNames.home);
      }
      messenger.showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Expense updated!' : 'Expense added!')),
      );
    } else {
      final err =
          ref.read(expenseControllerProvider) ?? 'Something went wrong';
      messenger.showSnackBar(
        SnackBar(content: Text(err), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep the auth state warm so the user's uid is resolved before saving.
    ref.watch(authStateProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: LoadingOverlay(
        isLoading: _saving,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    _buildFormCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    context.canPop() ? context.pop() : context.go(RouteNames.home),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
              const Spacer(),
            ],
          ),
          Text(
            _isEdit ? 'Edit Expense' : 'New Expense',
            style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Track your educational investment',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          AmountInput(
            amount: _amount,
            onChanged: (v) => setState(() {
              _amount = v;
              if (v > 0) _amountError = null;
            }),
          ),
          if (_amountError != null) ...[
            const SizedBox(height: 8),
            Text(
              _amountError!,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Description',
              controller: _descCtrl,
              hint: 'e.g. Advanced Calculus Textbook',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Description is required'
                  : null,
            ),
            const SizedBox(height: 20),
            Text('Category', style: AppTextStyles.titleMedium),
            const SizedBox(height: 10),
            CategoryPicker(
              selected: _category,
              onSelected: (c) => setState(() {
                _category = c;
                _categoryError = null;
              }),
            ),
            if (_categoryError != null) ...[
              const SizedBox(height: 8),
              Text(
                _categoryError!,
                style:
                    AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ],
            const SizedBox(height: 20),
            Text('Transaction date', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    const SizedBox(width: 10),
                    Text(formatDate(_date), style: AppTextStyles.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isIncome,
              activeThumbColor: AppColors.primary,
              title: Text('This is income (allowance, etc.)',
                  style: AppTextStyles.titleMedium),
              onChanged: (v) => setState(() => _isIncome = v),
            ),
            const SizedBox(height: 12),
            Text('Receipt', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            ReceiptUploader(
              file: _receiptFile,
              onTap: _openReceiptSheet,
              onRemove: () => setState(() => _receiptFile = null),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: _isEdit ? 'Save Changes' : 'Save Expense',
              onPressed: _save,
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go(RouteNames.home),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
