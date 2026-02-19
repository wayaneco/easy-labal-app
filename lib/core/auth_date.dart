import 'package:easy_laba/features/orders/provider/order_provider.dart';
import 'package:easy_laba/features/orders/service/order_service.dart';
import 'package:easy_laba/screens/login.dart';
import 'package:provider/provider.dart';
import '../features/orders/view/order_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session == null) {
          return LoginScreen();
        }

        return ChangeNotifierProvider(
          create: (_) => OrderProvider(OrderService()),
          child: OrderScreen(),
        );
      },
    );
  }
}
