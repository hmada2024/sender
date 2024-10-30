import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sender/email_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _recipientController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailProvider = Provider.of<EmailProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Send CV App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Your Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Your Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                label: 'Save Credentials',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    emailProvider.setCredentials(
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(labelText: 'Recipient Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the recipient email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                label: 'Send CV',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    emailProvider.sendEmail(
                      _recipientController.text,
                      'My CV',
                      'Please find my attached CV.',
                      ['path/to/your/cv.pdf'], // حدد مسار السيرة الذاتية هنا
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AnimatedButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
