import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import './widgets/custom_text_field.dart';
import './widgets/password_strength_indicator.dart';
import './widgets/social_signup_button.dart';
import './widgets/terms_privacy_links.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24),
                onPressed: () => Navigator.pop(context)),
            actions: [
              TextButton(
                  onPressed: () {
                    // Navigate to dashboard for preview mode
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.dashboardHome);
                  },
                  child: Text('Preview',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600))),
              SizedBox(width: 4.w),
            ]),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          _buildHeader(),
                          SizedBox(height: 4.h),
                          _buildRegistrationForm(),
                          SizedBox(height: 3.h),
                          _buildTermsAndConditions(),
                          SizedBox(height: 4.h),
                          _buildSignUpButton(),
                          SizedBox(height: 4.h),
                          _buildDivider(),
                          SizedBox(height: 3.h),
                          _buildSocialSignups(),
                          SizedBox(height: 4.h),
                          _buildLoginLink(),
                        ])))));
  }

  Widget _buildHeader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Create Account',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface)),
      SizedBox(height: 1.h),
      Text(
          'Join Alpha Skincare for personalized skin analysis and expert recommendations',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
    ]);
  }

  Widget _buildRegistrationForm() {
    return Form(
        key: _formKey,
        child: Column(children: [
          CustomTextField(
              controller: _fullNameController, 
              hint: 'Enter your full name',
              label: 'Full Name',
              validator: _validateFullName),
          SizedBox(height: 2.h),
          CustomTextField(
              controller: _emailController,
              hint: 'Enter your email address',
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail),
          SizedBox(height: 2.h),
          CustomTextField(
            controller: _passwordController,
            hint: 'Enter your password',
            label: 'Password',
            isPassword: true,
            validator: _validatePassword,
            onChanged: (value) =>
                setState(() {}), // Trigger rebuild for strength indicator
          ),
          SizedBox(height: 1.h),
          PasswordStrengthIndicator(password: _passwordController.text),
          SizedBox(height: 2.h),
          CustomTextField(
              controller: _confirmPasswordController,
              hint: 'Confirm your password',
              label: 'Confirm Password',
              isPassword: true,
              validator: _validateConfirmPassword),
        ]));
  }

  Widget _buildTermsAndConditions() {
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Checkbox(
            value: _acceptTerms,
            onChanged: (value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
            }),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 1.h),
          RichText(
              text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
                  children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500)),
                const TextSpan(text: ' and '),
                TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500)),
              ])),
        ])),
      ]),
      SizedBox(height: 1.h),
      const TermsPrivacyLinks(),
    ]);
  }

  Widget _buildSignUpButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: _acceptTerms && !_isLoading ? _handleSignUp : null,
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary)))
                : Text('Create Account',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600))));
  }

  Widget _buildDivider() {
    return Row(children: [
      Expanded(
          child: Divider(
              color: AppTheme.lightTheme.colorScheme.outline, thickness: 1)),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text('Or sign up with',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant))),
      Expanded(
          child: Divider(
              color: AppTheme.lightTheme.colorScheme.outline, thickness: 1)),
    ]);
  }

  Widget _buildSocialSignups() {
    return Column(children: [
      SocialSignupButton(
          onPressed: _handleGoogleSignup,
          backgroundColor: Colors.white,
          iconName: 'google',
          text: 'Sign up with Google',
          textColor: Colors.black87),
      SizedBox(height: 2.h),
      SocialSignupButton(
          onPressed: _handleAppleSignup,
          backgroundColor: Colors.black,
          iconName: 'apple',
          text: 'Sign up with Apple',
          textColor: Colors.white),
    ]);
  }

  Widget _buildLoginLink() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Already have an account? ',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
      TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.loginScreen);
          },
          child: Text('Sign In',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600))),
    ]);
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Please enter your full name (first and last name)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and numbers';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim());

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Account created successfully! Please check your email for verification.')));

        // Navigate to login screen
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignup() async {
    try {
      await _authService.signInWithGoogle();

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Google sign-up failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight));
      }
    }
  }

  Future<void> _handleAppleSignup() async {
    try {
      await _authService.signInWithApple();

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Apple sign-up failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight));
      }
    }
  }
}