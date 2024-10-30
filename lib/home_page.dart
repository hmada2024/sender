import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sender/email_provider.dart';
import 'package:sender/manage_emails_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _cvPath;

  Future<void> _pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _cvPath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider = Provider.of<EmailProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send CV App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageEmailsPage()),
              );
            },
          ),
        ],
      ),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Email Body'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the body of the email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickCV,
                child: Text(_cvPath == null ? 'Pick CV' : 'CV Picked: ${_cvPath!.split('/').last}'),
              ),
              const SizedBox(height: 20),
              AnimatedButton(
                label: 'Send CV',
                onPressed: () {
                  if (_formKey.currentState!.validate() && _cvPath != null) {
                    emailProvider.sendEmail(
                      _recipientController.text,
                      _subjectController.text,
                      _bodyController.text,
                      [_cvPath!], // مسار السيرة الذاتية المحدد
                    );
                  } else if (_cvPath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please pick a CV file')));
                  }
                },
              ),
              const SizedBox(height: 20),
              ...List.generate(emailProvider.savedEmails.length, (index) {
                return AnimatedButton(
                  label: 'Send by ${emailProvider.savedEmails[index]['email']}',
                  onPressed: () {
                    if (_cvPath != null) {
                      emailProvider.sendEmail(
                        _recipientController.text,
                        _subjectController.text,
                        _bodyController.text,
                        [_cvPath!],
                        emailIndex: index,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please pick a CV file')));
                    }
                  },
                );
              }),
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
