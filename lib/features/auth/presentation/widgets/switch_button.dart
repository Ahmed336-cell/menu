import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggleLogin;
  const SwitchButton({super.key, required this.isLogin, required this.onToggleLogin});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onToggleLogin,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF718096)),
          children: [
            TextSpan(text: isLogin ? "Don't have an account? " : "Already have an account? "),
            TextSpan(
              text: isLogin ? 'Sign Up' : 'Sign In',
              style: const TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 