import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../providers/settings_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(settingsProvider.notifier);
    await notifier.changePassword(_currentCtrl.text, _newCtrl.text);
    if (!mounted) return;
    final error = ref.read(settingsProvider).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.couldNotUpdatePassword)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.passwordUpdatedSuccess)),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.changePassword),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('current-password-field'),
                  controller: _currentCtrl,
                  obscureText: _obscure,
                  decoration: const InputDecoration(
                      labelText: AppStrings.currentPasswordLabel),
                  validator: (v) => (v == null || v.isEmpty)
                      ? AppStrings.currentPasswordRequired
                      : null,
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  key: const Key('new-password-field'),
                  controller: _newCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: AppStrings.newPasswordLabel,
                    suffixIcon: IconButton(
                      icon: Icon(_obscure
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  key: const Key('confirm-password-field'),
                  controller: _confirmCtrl,
                  obscureText: _obscure,
                  decoration: const InputDecoration(
                      labelText: AppStrings.confirmNewPasswordLabel),
                  validator: (v) =>
                      Validators.confirmPassword(v, _newCtrl.text),
                ),
                const SizedBox(height: AppSizes.xl),
                ElevatedButton(
                  onPressed: state.isLoading ? null : _onSubmit,
                  child: state.isLoading
                      ? const SizedBox(
                          width: AppSizes.space20,
                          height: AppSizes.space20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text(AppStrings.updatePasswordButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
