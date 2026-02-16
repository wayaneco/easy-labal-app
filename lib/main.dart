import 'package:easy_laba/core/auth_date.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:easy_laba/screens/login.dart';
import './features/orders/view/order_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://kgzqusvboqtmwutrxbvi.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnenF1c3Zib3F0bXd1dHJ4YnZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0ODQyODQsImV4cCI6MjA3NTA2MDI4NH0.lmq4kVUOvuu3mvL3lReqKRAJ1IHHdkveloVOeLOCwSQ",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Laba',
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (BuildContext context) => LoginScreen(),
        '/order': (BuildContext context) => OrderScreen(),
      },
    );
  }
}
