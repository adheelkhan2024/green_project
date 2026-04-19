import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController(text: 'admin@campus.edu');
  final password = TextEditingController(text: 'Admin123!');
  bool registerMode = false;
  String role = 'Student/User';
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.eco, size: 56, color: Color(0xFF168257)),
                      const SizedBox(height: 16),
                      Text(
                        'Sustainable Campus Tracker',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      const Text('Manage green campus initiatives with progress, teams, documents, and AI insights.', textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      if (registerMode)
                        TextFormField(
                          controller: name,
                          decoration: const InputDecoration(labelText: 'Full name'),
                          validator: (value) => Validators.requiredText(value, 'Name'),
                        ),
                      if (registerMode) const SizedBox(height: 12),
                      TextFormField(
                        controller: email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: password,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      if (registerMode) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: role,
                          decoration: const InputDecoration(labelText: 'Role'),
                          items: const [
                            DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                            DropdownMenuItem(value: 'Student/User', child: Text('Student/User')),
                          ],
                          onChanged: (value) => setState(() => role = value ?? role),
                        ),
                      ],
                      if (error != null) ...[
                        const SizedBox(height: 12),
                        Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: submit,
                        child: Text(registerMode ? 'Create account' : 'Login'),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          error = null;
                          registerMode = !registerMode;
                        }),
                        child: Text(registerMode ? 'Already have an account? Login' : 'Need an account? Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    final controller = context.read<AppController>();
    final message = registerMode
        ? await controller.register(name.text, email.text, password.text, role)
        : await controller.login(email.text, password.text);
    if (!mounted) return;
    if (message == null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() => error = message);
    }
  }
}