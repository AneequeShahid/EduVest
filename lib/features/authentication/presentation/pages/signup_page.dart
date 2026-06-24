import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/route_names.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '_auth_colors.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authNotifierProvider.notifier).signup(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
          _nameCtrl.text.trim(),
        );

    if (!mounted) return;
    final authAsync = ref.read(authNotifierProvider);
    if (authAsync.hasError) {
      _showError(authAsync.error!.toString());
    } else if (authAsync.valueOrNull != null) {
      // Navigate explicitly; the router guard also redirects as a fallback.
      context.go(RouteNames.home);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AuthColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.space28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.xxl),

                    // Back + Logo row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: AppSizes.space40,
                            height: AppSizes.space40,
                            decoration: BoxDecoration(
                              color: AuthColors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                              border: Border.all(color: AuthColors.border),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                size: AppSizes.space18, color: AuthColors.textDark),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          AppStrings.appName,
                          style: TextStyle(
                            fontSize: AppSizes.font22,
                            fontWeight: FontWeight.w400,
                            color: AuthColors.primary,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),

                    const SizedBox(height: AppSizes.space36),

                    // Heading
                    const Text(
                      AppStrings.createAccountHeading,
                      style: TextStyle(
                        fontSize: AppSizes.font26,
                        fontWeight: FontWeight.w600,
                        color: AuthColors.textDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space6),
                    const Text(
                      AppStrings.signupSubtitle,
                      style: TextStyle(
                          fontSize: AppSizes.font15, color: AuthColors.textMuted),
                    ),

                    const SizedBox(height: AppSizes.xl),

                    // Full name
                    AuthTextField(
                      label: AppStrings.fullNameLabel,
                      hint: AppStrings.fullNameHint,
                      controller: _nameCtrl,
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return AppStrings.validateNameRequired;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.space18),

                    // Email
                    AuthTextField(
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

                    const SizedBox(height: AppSizes.space18),

                    // Password
                    AuthTextField(
                      label: AppStrings.passwordLabel,
                      hint: AppStrings.signupPasswordHint,
                      controller: _passwordCtrl,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return AppStrings.validatePasswordEnter;
                        }
                        if (v.length < 8) {
                          return AppStrings.validatePasswordMin;
                        }
                        if (!v.contains(RegExp(r'[0-9]'))) {
                          return AppStrings.validatePasswordNumber;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.space18),

                    // Confirm password
                    AuthTextField(
                      label: AppStrings.confirmPasswordLabel,
                      hint: AppStrings.passwordHint,
                      controller: _confirmCtrl,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: (v) {
                        if (v != _passwordCtrl.text) {
                          return AppStrings.validatePasswordMismatch;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.xl),

                    // Create Account button
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.space54,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onCreateAccount,
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
                            : const Text(AppStrings.createAccountButton),
                      ),
                    ),

                    const SizedBox(height: AppSizes.lg),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.haveAccountQ,
                          style: TextStyle(
                              color: AuthColors.textMuted, fontSize: AppSizes.fontMd),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: AuthColors.primary,
                            padding:
                                const EdgeInsets.symmetric(horizontal: AppSizes.space6),
                          ),
                          child: const Text(
                            AppStrings.signIn,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: AppSizes.fontMd),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
