import 'package:ai_chat/ai_chat.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ai Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AiChatView(),
    );
  }
}
