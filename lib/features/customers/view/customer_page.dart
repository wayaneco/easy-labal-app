import 'package:easy_laba/components/drawer.dart';
import 'package:easy_laba/features/customers/model/customer_model.dart';
import 'package:easy_laba/features/customers/provider/customer_provider.dart';
import 'package:easy_laba/helpers/capitalize_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: CustomDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [_buildCustomerList(context)],
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: const Color(0xFF3B82F6),
    elevation: 0,
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.filter_list, color: Colors.white),
        onPressed: () {},
        tooltip: 'Filter',
      ),
    ],
  );
}

Widget _buildCustomerCard({required String name, required String phone}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
              child: Text(
                name.substring(0, 1).toCapitalized(),
                style: const TextStyle(
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toCapitalized(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    phone,
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCustomerList(BuildContext context) {
  final customers = context.watch<CustomerProvider>().customers;

  return Expanded(
    child: RefreshIndicator(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int i) {
          CustomerModel customer = customers[i];

          return _buildCustomerCard(
            name: customer.fullName,
            phone: customer.phone,
          );
        },
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        separatorBuilder: (_, __) => SizedBox(height: 8.0),
        itemCount: customers.length,
      ),
      onRefresh: () async {},
    ),
  );
}
