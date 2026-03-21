import 'package:flutter/material.dart';

import '../models/drawer.model.dart';

List<DrawerItem> drawerItems = [
  DrawerItem(Icons.shopping_bag_outlined, 'Orders', '/orders'),
  DrawerItem(Icons.people_outline, 'Customers', '/customers'),
  DrawerItem(Icons.money_outlined, 'Expenses', '/expenses'),
  DrawerItem(Icons.inventory_2_outlined, 'Inventory', '/inventory'),
];
