import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailProvider with ChangeNotifier {
  List<Map<String, String>> savedEmails = [];

  void setCredentials(String email, String pass) {
    if (savedEmails.length < 3) {
      savedEmails.add({'email': email, 'password': pass});
      notifyListeners();
    } else {
      // يمكنك تنفيذ رمز الإشعار هنا لتخبر المستخدم أنه يمكنه حفظ 3 بريد إلكتروني فقط
    }
  }

  void removeCredentials(int index) {
    if (index < savedEmails.length) {
      savedEmails.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> sendEmail(String recipientEmail, String subject, String body, List<String> attachmentPaths, {int? emailIndex}) async {
    String fromEmail;
    String password;

    if (emailIndex != null && emailIndex < savedEmails.length) {
      fromEmail = savedEmails[emailIndex]['email']!;
      password = savedEmails[emailIndex]['password']!;
    } else {
      return; // لا يمكن الإرسال بدون بيانات الاعتماد
    }

    final smtpServer = gmail(fromEmail, password);

    final message = Message()
      ..from = Address(fromEmail)
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
