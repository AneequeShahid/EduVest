import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/route_names.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '_auth_colors.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authNotifierProvider.notifier)
        .login(_emailCtrl.text.trim(), _passwordCtrl.text);

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
                    const SizedBox(height: AppSizes.space56),

                    // Logo + wordmark
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: AppSizes.space68,
                            height: AppSizes.space68,
                            decoration: BoxDecoration(
                              color: AuthColors.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusCard),
                              boxShadow: [
                                BoxShadow(
                                  color: AuthColors.primary.withValues(alpha: 0.25),
                                  blurRadius: AppSizes.md,
                                  offset: const Offset(0, 6),
                                ],
                              ],
                            ),
                            child: const Icon(Icons.school_rounded,
                                color: Colors.white, size: AppSizes.font38),
                          ),
                          const SizedBox(height: AppSizes.space14),
                          const Text(
                            AppStrings.appName,
                            style: TextStyle(
                              fontSize: AppSizes.fontDisplayLg,
                              fontWeight: FontWeight.w400,
                              color: AuthColors.primary,
                              fontFamily: 'Georgia',
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: AppSizes.space6),
                          const Text(
                            AppStrings.appTagline,
                            style: TextStyle(
                              fontSize: AppSizes.fontMd,
                              color: AuthColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.space44),

                    // Heading
                    const Text(
                      AppStrings.welcomeBack,
                      style: TextStyle(
                        fontSize: AppSizes.font26,
                        fontWeight: FontWeight.w600,
                        color: AuthColors.textDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space6),
                    const Text(
                      AppStrings.loginSubtitle,
                      style: TextStyle(
                          fontSize: AppSizes.font15, color: AuthColors.textMuted),
                    ),

                    const SizedBox(height: AppSizes.xl),

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
                      hint: AppStrings.passwordHint,
                      controller: _passwordCtrl,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return AppStrings.validatePasswordRequired;
                        }
                        return null;
                      },
                    ),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(RouteNames.forgotPassword),
                        style: TextButton.styleFrom(
                          foregroundColor: AuthColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.xs, vertical: AppSizes.sm),
                        ),
                        child: const Text(
                          AppStrings.forgotPasswordQ,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: AppSizes.fontMd),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.sm),

                    // Sign In button
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.space54,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onSignIn,
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
                            : const Text(AppStrings.signIn),
                      ),
                    ),

                    const SizedBox(height: AppSizes.space28),

                    // Sign up row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.noAccountQ,
                          style: TextStyle(
                              color: AuthColors.textMuted, fontSize: AppSizes.fontMd),
                        ),
                        TextButton(
                          onPressed: () => context.push(RouteNames.signup),
                          style: TextButton.styleFrom(
                            foregroundColor: AuthColors.primary,
                            padding:
                                const EdgeInsets.symmetric(horizontal: AppSizes.space6),
                          ),
                          child: const Text(
                            AppStrings.signup,
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
