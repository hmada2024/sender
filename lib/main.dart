import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sender/email_provider.dart';
import 'package:sender/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmailProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white70,
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.blueAccent,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
