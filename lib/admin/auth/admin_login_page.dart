import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '../admin_constants.dart';
import '../design/admin_tokens.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });

    final user = await authManager.signInWithEmail(
      context,
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (user != null && FirebaseAuth.instance.currentUser?.email != kAdminEmail) {
      await authManager.signOut();
      setState(() {
        _error = 'This account is not authorized for admin access.';
        _submitting = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() => _submitting = false);
    // On success the router's redirect (driven by AdminAuthNotifier) takes
    // over automatically — nothing to navigate to here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.surface,
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: AdminColors.oxblood,
              padding: const EdgeInsets.all(AdminSpace.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('NELWA', style: AdminType.display(40, weight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: AdminSpace.xs),
                  Text('ACADEMY', style: AdminType.eyebrow(color: AdminColors.terracotta).copyWith(fontSize: 14)),
                  const SizedBox(height: AdminSpace.xxl),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 340),
                    child: Text(
                      'The operations desk for courses, people, and payouts — everything that keeps the school running.',
                      style: AdminType.body(15, color: AdminColors.onRail).copyWith(height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Padding(
                  padding: const EdgeInsets.all(AdminSpace.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Sign in', style: AdminType.display(24, weight: FontWeight.w600)),
                      const SizedBox(height: AdminSpace.xs),
                      Text(
                        'Use your admin account to continue.',
                        style: AdminType.body(13, color: AdminColors.inkFaint),
                      ),
                      const SizedBox(height: AdminSpace.xxl),
                      Text('EMAIL', style: AdminType.eyebrow()),
                      const SizedBox(height: AdminSpace.xs),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AdminType.body(14),
                        decoration: _fieldDecoration(),
                      ),
                      const SizedBox(height: AdminSpace.lg),
                      Text('PASSWORD', style: AdminType.eyebrow()),
                      const SizedBox(height: AdminSpace.xs),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: AdminType.body(14),
                        onSubmitted: (_) => _submitting ? null : _submit(),
                        decoration: _fieldDecoration(),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: AdminSpace.lg),
                        Container(
                          padding: const EdgeInsets.all(AdminSpace.md),
                          decoration: BoxDecoration(
                            color: AdminColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AdminRadius.sm),
                          ),
                          child: Text(
                            _error!,
                            style: AdminType.body(13, color: AdminColors.error),
                          ),
                        ),
                      ],
                      const SizedBox(height: AdminSpace.xl),
                      SizedBox(
                        height: 46,
                        child: FilledButton(
                          onPressed: _submitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AdminColors.oxblood,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AdminRadius.sm),
                            ),
                          ),
                          child: _submitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text('Sign in', style: AdminType.body(14, weight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration() => InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: AdminSpace.md, vertical: AdminSpace.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminRadius.sm),
          borderSide: const BorderSide(color: AdminColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminRadius.sm),
          borderSide: const BorderSide(color: AdminColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminRadius.sm),
          borderSide: const BorderSide(color: AdminColors.oxblood, width: 1.5),
        ),
      );
}
