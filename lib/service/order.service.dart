import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/order.model.dart';

class OrderService {
  final _client = Supabase.instance.client;

  Future<List<OrderModel>> fetchOrders() async {
    final response = await _client.from('view_orders').select('*');

    return response.map((e) => OrderModel.fromJson(e)).toList();
  }
}
