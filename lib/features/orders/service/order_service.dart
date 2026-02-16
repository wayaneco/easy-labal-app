import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/order_model.dart';

class OrderService {
  final _client = Supabase.instance.client;

  Future<List<OrderModel>> fetchOrders({
    String? search,
    String? branchId,
    OrderStatus? orderStatus,
    DateTimeRange? date,
  }) async {
    var query = _client.from('view_orders').select('*');

    if (search != null && search.isNotEmpty) {
      query = query.or(
        'customer_name.ilike.%$search%,order_id.ilike.%$search%',
      );
    }

    if (branchId != null && branchId.isNotEmpty) {
      query = query.eq('branchId', branchId);
    }

    if (orderStatus != null) {
      query = query.eq('order_status', getOrderStatusRevered(orderStatus));
    }

    if (date != null) {
      query = query
          .gte('created_at', date.start.toIso8601String())
          .lte('created_at', date.end.toIso8601String());
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List).map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<void> updatePaymentStatus(
    String order_id,
    PaymentStatus status,
    String staff_id,
  ) async {
    try {
      await _client.rpc(
        'update_order_status',
        params: {
          'p_order_id': order_id,
          'p_order_status': getPaymentStatusRevered(status),
          'p_staff_id': staff_id,
        },
      );
    } catch (err) {}
  }
}
