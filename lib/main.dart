import 'package:flutter/material.dart';

void main() async {
  runApp(const IsolApp());    
}

class IsolApp extends StatelessWidget {
  const IsolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: IsolHomePage());
  }
}

class IsolHomePage extends StatelessWidget {
  const IsolHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome to IsolApp!'),
      ),
    );
  }
}