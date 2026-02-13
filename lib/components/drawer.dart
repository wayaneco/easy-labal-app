import 'package:flutter/material.dart';

import '../constants/drawer_items.dart';

Widget _buildDrawerHeader() {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.local_laundry_service,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Easy Laba',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Laundry Management',
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        ),
      ],
    ),
  );
}

Widget _buildDrawerItem({
  required IconData icon,
  required String title,
  bool isSelected = false,
  required String path,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white70,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        print(path);
      },
    ),
  );
}

Widget _buildDrawerFooter() {
  return Container(
    padding: const EdgeInsets.all(16),
    child: ListTile(
      leading: const Icon(Icons.logout, color: Colors.white70, size: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Logout', style: TextStyle(color: Colors.white70)),
      onTap: () {},
    ),
  );
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: drawerItems.map((item) {
                  return _buildDrawerItem(
                    icon: item.icon,
                    title: item.title,
                    path: item.path,
                  );
                }).toList(),
              ),
            ),
            _buildDrawerFooter(),
          ],
        ),
      ),
    );
  }
}
