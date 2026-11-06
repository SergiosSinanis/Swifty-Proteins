import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_state.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/navy_background.dart';
import '../../widgets/success_snack_bar.dart';
import 'widgets/app_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    if (username.isEmpty || password.length < 8 || !hasLetter || !hasDigit) {
      ErrorDialog.show(
        context,
        title: 'Check your details',
        message: 'Username cannot be empty and password must have at least 8 characters, with a letter and a digit.',
      );
      return;
    }

    final auth = context.read<AuthState>();
    setState(() => _isSubmitting = true);
    final success = await auth.register(username, password);
    if (!mounted)
      return;
    setState(() => _isSubmitting = false);

    if (success) {
      SuccessSnackBar.show(context, message: 'Account created. You can now log in.');
      Navigator.of(context).pop();
    } else {
      ErrorDialog.show(
        context,
        title: 'Registration failed',
        message: auth.lastError ?? 'Please try again.',
      );
    }
  }

  // the colors and shapes of the bar, fields and button come from app_theme.dart
  @override
  Widget build(BuildContext context) {
    return NavyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // the gradient painted by NavyBackground shows through
        appBar: AppBar(title: const Text('Create account')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppLogo(),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    helperText: 'At least 8 characters, with a letter and a digit',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
