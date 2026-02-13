import 'package:flutter/material.dart';

import '../models/drawer.model.dart';

List<DrawerItem> drawerItems = [
  DrawerItem(Icons.shopping_bag_outlined, 'Orders', '/orders'),
  DrawerItem(Icons.people_outline, 'Customers', ''),
  DrawerItem(Icons.analytics_outlined, 'Analytics', ''),
  DrawerItem(Icons.settings_outlined, 'Settings', ''),
];
