import 'package:flutter/material.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'submit_button.dart';
import 'switch_button.dart';

class AuthCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLogin;
  final bool obscurePassword;
  final VoidCallback onSubmit;
  final VoidCallback onToggleLogin;
  final VoidCallback onToggleObscure;
  final bool isLoading;

  const AuthCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLogin,
    required this.obscurePassword,
    required this.onSubmit,
    required this.onToggleLogin,
    required this.onToggleObscure,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isLogin ? 'Welcome Back!' : 'Create Account',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            EmailField(controller: emailController),
            const SizedBox(height: 18),
            PasswordField(controller: passwordController, obscureText: obscurePassword, onToggleObscure: onToggleObscure),
            const SizedBox(height: 32),
            SubmitButton(isLoading: isLoading, onPressed: onSubmit, isLogin: isLogin),
            const SizedBox(height: 18),
            SwitchButton(isLogin: isLogin, onToggleLogin: onToggleLogin),
          ],
        ),
      ),
    );
  }
} 