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
              ...OrderStatus.values.map(
                (status) => ListTile(
                  selected: status == OrderStatus.all
                      ? selectedStatus == null
                      : selectedStatus == status,
                  onTap: () {
                    Navigator.pop(context, status);
                  },
                  title: Text(getOrderStatusRevered(status)),
                  leading: Radio<OrderStatus?>(
                    value: status == OrderStatus.all ? null : status,
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
