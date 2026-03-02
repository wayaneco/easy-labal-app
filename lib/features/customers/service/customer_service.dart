import 'package:easy_laba/features/customers/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerService extends ChangeNotifier {
  final SupabaseClient client;

  CustomerService(this.client);

  List<CustomerModel> customers = [];

  Future<void> getCustomers() async {
    try {
      final result = await client.from('view_customers').select();

      print('======================== $result');
      customers = result
          .map(
            (Map<String, dynamic> json) => CustomerModel(
              id: json['customer_id'],
              firstName: json['first_name'],
              middleName: json['middle_name'],
              lastName: json['last_name'],
              fullName: json['full_name'],
              phone: json['phone'],
              email: json['email'],
              address: json['address'],
            ),
          )
          .toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching customers: $error');
    }
  }
}
