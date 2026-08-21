import 'package:flutter/material.dart';

void main() {
  runApp(const ZenUApp());
}

class ZenUApp extends StatefulWidget {
  const ZenUApp({super.key});

  @override
  State<ZenUApp> createState() => _ZenUAppState();
}

class _ZenUAppState extends State<ZenUApp> {
  @override
  void initState() {
    super.initState();
    // Simulate greeting sequence timer
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZenU',
      home: Scaffold(
        appBar: AppBar(title: const Text('ZenU')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Design System Showcase'),
              Text('TEMPORARY DEVELOPMENT PLACEHOLDER'),
            ],
          ),
        ),
      ),
    );
  }
}
