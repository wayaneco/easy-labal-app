import 'package:easy_laba/helpers/capitalize_text.dart';
import 'package:flutter/material.dart';

import 'package:easy_laba/features/orders/model/order_model.dart';

import 'package:easy_laba/utils/date_formater.dart';

Color _getStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return const Color(0xFF3B82F6);
    case OrderStatus.ongoing:
      return const Color(0xFFF59E0B);
    case OrderStatus.readyForPickUp:
      return const Color(0xFFF8DB38);
    case OrderStatus.pickedUp:
      return const Color(0xFF10B981);
    case OrderStatus.all:
      return Colors.transparent;
  }
}

Color _getPaymentStatusColor(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.paid:
      return const Color(0xFF10B981);
    case PaymentStatus.unpaid:
      return const Color(0xFFF59E0B);
  }
}

class OrderDetail extends StatelessWidget {
  final OrderModel order;

  const OrderDetail({super.key, required this.order});

  Future<void> _updatePaymentStatusDialog(BuildContext context) async {
    final PaymentStatus? result = await showAdaptiveDialog(
      context: context,
      builder: (BuildContext dContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(dContext, PaymentStatus.paid);
                },
                title: Text('Paid'),
                leading: Radio(
                  value: PaymentStatus.paid,
                  onChanged: (newValue) {
                    Navigator.pop(dContext, PaymentStatus.paid);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      // padding: EdgeInsets.only(bottom: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.numbers,
                        color: Color(0xFF3B82F6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.order_id,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            formatDateTime('MMMM dd, yyyy', order.date),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(color: Color(0xFFEBEBEB)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF3B82F6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName.toCapitalized(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          if (order.phone_number != null)
                            Text(
                              order.phone_number!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard(
                        icon: Icons.inventory_2,
                        label: 'Items',
                        value: '${order.itemsCount}',
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailCard(
                        icon: Icons.payments_outlined,
                        label: 'Total',
                        value: '₱${order.price.toStringAsFixed(0)}',
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Payment Status',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          Material(
                            color: _getPaymentStatusColor(
                              order.payment_status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                            type: MaterialType.button,
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              onTap: order.payment_status == PaymentStatus.paid
                                  ? null
                                  : () => _updatePaymentStatusDialog(context),
                              child: Container(
                                padding: EdgeInsets.all(
                                  10,
                                ).add(EdgeInsetsGeometry.only(left: 8)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        getPaymentStatusRevered(
                                          order.payment_status,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _getPaymentStatusColor(
                                            order.payment_status,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      order.payment_status == PaymentStatus.paid
                                          ? Icons.check
                                          : Icons.arrow_drop_down_outlined,
                                      color: _getPaymentStatusColor(
                                        order.payment_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Status',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          Material(
                            color: _getStatusColor(
                              order.order_status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                            type: MaterialType.button,
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(
                                  10,
                                ).add(EdgeInsetsGeometry.only(left: 8)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        getOrderStatusRevered(
                                          order.order_status,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(
                                            order.order_status,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: _getStatusColor(
                                        order.order_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          foregroundColor: const Color(0xFF64748B),
                          fixedSize: Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
