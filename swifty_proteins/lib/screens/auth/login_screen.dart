import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../state/auth_state.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/navy_background.dart';
import 'widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // create the State object that contains the screen's logic and UI
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // variables to control the 2 user input fields (username + password)
  final _usernameController = TextEditingController(); // it's an object that lets control and read the text entered by the user in a TextField = needs cleaning
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _biometricsAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

// this method checks if biometroics are available 
  Future<void> _checkBiometrics() async {
    final available = await context.read<AuthState>().biometricsAvailable();
    if (!mounted)
      return;
    setState(() => _biometricsAvailable = available);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitPassword() async {
    final auth = context.read<AuthState>();
    setState(() => _isSubmitting = true);
    final success = await auth.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
    if (!mounted)
      return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.ligandList);
    } else {
      ErrorDialog.show(context, title: 'Login failed', message: auth.lastError ?? 'Please try again.');
    }
  }

  Future<void> _submitBiometrics() async {
    final auth = context.read<AuthState>();
    final success = await auth.loginWithBiometrics();
    if (!mounted)
      return;

    if (success) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.ligandList);
    } else {
      ErrorDialog.show(context, title: 'Authentication failed', message: auth.lastError ?? 'Please try again.');
    }
  }

  // the colors and shapes of the bar, fields and buttons come from app_theme.dart
  @override
  Widget build(BuildContext context) {
    return NavyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // the gradient painted by NavyBackground shows through
        appBar: AppBar(title: const Text('Login')),
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
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPassword,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Log in'),
                ),
                if (_biometricsAvailable) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _submitBiometrics,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Log in with biometrics'),
                  ),
                ],
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
                  child: const Text('Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
