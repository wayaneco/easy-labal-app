import 'package:easy_laba/features/orders/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderStatusFilter extends StatelessWidget {
  final OrderStatus? selectedStatus;

  const OrderStatusFilter({super.key, required this.selectedStatus});

  @override
  Widget build(BuildContext _) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
          title: const Text('Filter Orders'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                selected: selectedStatus == null,
                title: const Text('All'),
                hoverColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Radio<OrderStatus?>(
                  value: null,
                  hoverColor: Colors.transparent,
                  groupValue: selectedStatus,
                  onChanged: (_) {
                    Navigator.pop(context);
                  },
                ),
                trailing: null,
              ),
              ...OrderStatus.values.map(
                (status) => ListTile(
                  selected: selectedStatus == status,
                  onTap: () {
                    Navigator.pop(context, status);
                  },
                  title: Text(getOrderStatusRevered(status)),
                  leading: Radio<OrderStatus?>(
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      Navigator.pop(context, status);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
