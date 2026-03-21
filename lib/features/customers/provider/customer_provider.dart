import 'package:easy_laba/features/customers/service/customer_service.dart';
import 'package:flutter/material.dart';

import '../model/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerService service;

  CustomerProvider(this.service);

  List<CustomerModel> customers = [];

  Future<void> fetchCustomers() async {
    customers = await service.getCustomers();
    notifyListeners();
  }
}
