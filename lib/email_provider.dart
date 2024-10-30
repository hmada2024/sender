import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailProvider with ChangeNotifier {
  String? fromEmail;
  String? password;

  void setCredentials(String email, String pass) {
    fromEmail = email;
    password = pass;
    notifyListeners();
  }

  Future<void> sendEmail(String recipientEmail, String subject, String body, List<String> attachmentPaths) async {
    final smtpServer = gmail(fromEmail!, password!);

    final message = Message()
      ..from = Address(fromEmail!)
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body
      ..attachments = attachmentPaths.map((path) => FileAttachment(File(path))).toList();

    try {
      final sendReport = await send(message, smtpServer);
      if (kDebugMode) {
        print('Message sent: $sendReport');
      }
    } on MailerException catch (e) {
      if (kDebugMode) {
        print('Message not sent. \n${e.message}');
      }
    }
  }
}
