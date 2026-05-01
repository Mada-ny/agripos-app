import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../providers/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  String? _validationError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() => _validationError = 'Email address is required.');
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _validationError = 'Please enter a valid email address.');
      return;
    }
    if (password.isEmpty) {
      setState(() => _validationError = 'Password is required.');
      return;
    }

    setState(() => _validationError = null);
    ref.read(loginNotifierProvider.notifier).submit(email, password);
  }

  String? _extractApiError(Object error) {
    if (error is! AppException) return error.toString();
    final emailErrors = error.errors?['email'];
    if (emailErrors is List && emailErrors.isNotEmpty) {
      return emailErrors.first.toString();
    }
    return error.message;
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState.isLoading;
    final apiError = loginState.hasError
        ? _extractApiError(loginState.error!)
        : null;
    final errorMessage = _validationError ?? apiError;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BrandRow(),
              const SizedBox(height: 48),
              const Text(
                'Welcome back.',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF231a10),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to manage farmer accounts and record sales.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6b5d48),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),
              _LabeledField(
                label: 'Email',
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  enabled: !isLoading,
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                  decoration: const InputDecoration(
                    hintText: 'operator@coopcivoire.ci',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _LabeledField(
                label: 'Password',
                child: TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: isLoading
                          ? null
                          : () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                    ),
                  ),
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Color(0xFFb3321b),
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right, size: 20),
                          ],
                        ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Coopérative Agricole de Côte d\'Ivoire',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFa89a82),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2d5d3a),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AgriPOS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF231a10),
              ),
            ),
            Text(
              'FIELD OPERATOR',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6b5d48),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6b5d48),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
