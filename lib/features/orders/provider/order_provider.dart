import 'package:easy_laba/features/orders/model/order_model.dart';
import 'package:easy_laba/features/orders/service/order_service.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService orderService;

  OrderProvider(this.orderService);

  bool _isLoading = false;
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders({
    String? search,
    OrderStatus? orderStatus,
    DateTimeRange? dateFilter,
  }) async {
    _isLoading = true;
  }
}
