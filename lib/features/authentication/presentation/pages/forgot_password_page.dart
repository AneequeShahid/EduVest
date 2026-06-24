import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '_auth_colors.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _linkSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSendLink() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authNotifierProvider.notifier)
        .resetPassword(_emailCtrl.text.trim());

    if (!mounted) return;
    final authAsync = ref.read(authNotifierProvider);
    if (authAsync.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authAsync.error!.toString()),
          backgroundColor: AuthColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ),
      );
    } else {
      setState(() => _linkSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.space28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.lg),

              // Back button
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: AppSizes.space40,
                  height: AppSizes.space40,
                  decoration: BoxDecoration(
                    color: AuthColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: AuthColors.border),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: AppSizes.space18, color: AuthColors.textDark),
                ),
              ),

              const SizedBox(height: AppSizes.space36),

              if (_linkSent) ...[
                // ── Success state ──────────────────────────────────────
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: AppSizes.space80,
                        height: AppSizes.space80,
                        decoration: BoxDecoration(
                          color: AuthColors.successSurface,
                          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                        ),
                        child: const Icon(Icons.mark_email_read_outlined,
                            size: AppSizes.space44, color: AuthColors.success),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      const Text(
                        AppStrings.checkYourEmail,
                        style: TextStyle(
                          fontSize: AppSizes.fontXxl,
                          fontWeight: FontWeight.w600,
                          color: AuthColors.textDark,
                        ),
                      ),
                      const SizedBox(height: AppSizes.space12),
                      Text(
                        '${AppStrings.resetLinkSentTo}\n${_emailCtrl.text.trim()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: AppSizes.font15,
                            color: AuthColors.textMuted,
                            height: 1.5),
                      ),
                      const SizedBox(height: AppSizes.space40),
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.space54,
                        child: ElevatedButton(
                          onPressed: () => context.pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AuthColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radius14)),
                            elevation: 0,
                          ),
                          child: const Text(AppStrings.backToSignIn,
                              style: TextStyle(
                                  fontSize: AppSizes.fontLg,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // ── Input state ────────────────────────────────────────
                const Text(
                  AppStrings.resetPasswordHeading,
                  style: TextStyle(
                    fontSize: AppSizes.font26,
                    fontWeight: FontWeight.w600,
                    color: AuthColors.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSizes.space10),
                const Text(
                  AppStrings.resetPasswordSubtitle,
                  style: TextStyle(
                      fontSize: AppSizes.font15,
                      color: AuthColors.textMuted,
                      height: 1.5),
                ),

                const SizedBox(height: AppSizes.space36),

                Form(
                  key: _formKey,
                  child: AuthTextField(
                    label: AppStrings.emailLabel,
                    hint: AppStrings.emailHint,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return AppStrings.validateEmailRequired;
                      }
                      if (!v.contains('@') || !v.contains('.')) {
                        return AppStrings.validateEmailInvalid;
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: AppSizes.space28),

                SizedBox(
                  width: double.infinity,
                  height: AppSizes.space54,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _onSendLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuthColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AuthColors.primary.withValues(alpha: 0.55),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius14)),
                      elevation: 0,
                      textStyle: const TextStyle(
                          fontSize: AppSizes.fontLg, fontWeight: FontWeight.w600),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: AppSizes.space22,
                            height: AppSizes.space22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text(AppStrings.sendResetLink),
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
