import 'package:flutter/material.dart';

class NewOrderSheet extends StatelessWidget {
  const NewOrderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [Text("Hello")]),
    );
  }
}
