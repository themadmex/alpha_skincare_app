import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import './widgets/biometric_prompt_dialog.dart';
import './widgets/custom_text_field.dart';
import './widgets/loading_button.dart';
import './widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
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
                          SizedBox(height: 4.h),
                          _buildHeader(),
                          SizedBox(height: 6.h),
                          _buildLoginForm(),
                          SizedBox(height: 3.h),
                          _buildForgotPassword(),
                          SizedBox(height: 4.h),
                          _buildLoginButton(),
                          SizedBox(height: 3.h),
                          _buildBiometricLogin(),
                          SizedBox(height: 4.h),
                          _buildDivider(),
                          SizedBox(height: 3.h),
                          _buildSocialLogins(),
                          SizedBox(height: 4.h),
                          _buildSignUpLink(),
                        ])))));
  }

  Widget _buildHeader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Welcome Back',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface)),
      SizedBox(height: 1.h),
      Text('Continue your skincare journey with personalized insights',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
    ]);
  }

  Widget _buildLoginForm() {
    return Form(
        key: _formKey,
        child: Column(children: [
          CustomTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              hint: 'Enter your email',
              iconName: 'email',
              label: 'Email'),
          SizedBox(height: 2.h),
          CustomTextField(
              controller: _passwordController,
              isPassword: true,
              validator: _validatePassword,
              hint: 'Enter your password',
              iconName: 'lock',
              label: 'Password'),
          SizedBox(height: 1.h),
          Row(children: [
            Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                }),
            Text('Remember me',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
          ]),
        ]));
  }

  Widget _buildForgotPassword() {
    return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: _handleForgotPassword,
            child: Text('Forgot Password?',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500))));
  }

  Widget _buildLoginButton() {
    return LoadingButton(
        onPressed: _handleLogin, isLoading: _isLoading, text: 'Sign In');
  }

  Widget _buildBiometricLogin() {
    return Center(
        child: TextButton(
            onPressed: _showBiometricDialog,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              CustomIconWidget(
                  iconName: 'fingerprint',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20),
              SizedBox(width: 2.w),
              Text('Use Biometric Login',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500)),
            ])));
  }

  Widget _buildDivider() {
    return Row(children: [
      Expanded(
          child: Divider(
              color: AppTheme.lightTheme.colorScheme.outline, thickness: 1)),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text('Or continue with',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant))),
      Expanded(
          child: Divider(
              color: AppTheme.lightTheme.colorScheme.outline, thickness: 1)),
    ]);
  }

  Widget _buildSocialLogins() {
    return Column(children: [
      SocialLoginButton(
          onPressed: _handleGoogleLogin,
          iconName: 'google',
          label: 'Continue with Google'),
      SizedBox(height: 2.h),
      SocialLoginButton(
          onPressed: _handleAppleLogin,
          iconName: 'apple',
          label: 'Continue with Apple'),
    ]);
  }

  Widget _buildSignUpLink() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Don\'t have an account? ',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
      TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.registrationScreen);
          },
          child: Text('Sign Up',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600))),
    ]);
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
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text);

      if (mounted) {
        // Navigate to dashboard on successful login
        Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      await _authService.signInWithGoogle();

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Google sign-in failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight));
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    try {
      await _authService.signInWithApple();

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Apple sign-in failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight));
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter your email address first')));
      return;
    }

    try {
      await _authService.resetPassword(_emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Password reset email sent. Check your inbox.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to send reset email: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight));
      }
    }
  }

  void _showBiometricDialog() {
    showDialog(
        context: context,
        builder: (context) => BiometricPromptDialog(
            biometricType: 'fingerprint',
            onAuthenticate: () async {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
            },
            onCancel: () => Navigator.of(context).pop()));
  }
}