import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sender/email_provider.dart';

class ManageEmailsPage extends StatelessWidget {
  const ManageEmailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailProvider = Provider.of<EmailProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Emails'),
      ),
      body: ListView.builder(
        itemCount: emailProvider.savedEmails.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(emailProvider.savedEmails[index]['email']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(context, emailProvider, index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    emailProvider.removeCredentials(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, EmailProvider emailProvider, int index) {
    final emailController = TextEditingController(text: emailProvider.savedEmails[index]['email']);
    final passwordController = TextEditingController(text: emailProvider.savedEmails[index]['password']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                emailProvider.savedEmails[index] = {
                  'email': emailController.text,
                  'password': passwordController.text,
                };
                emailProvider.notifyListeners();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
