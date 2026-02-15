enum OrderStatus { pending, ongoing, readyForPickUp, pickedUp }

enum PaymentStatus { paid, unpaid }

OrderStatus getOrderStatus(String status) {
  switch (status) {
    case 'Pending':
      return OrderStatus.pending;
    case 'Ongoing':
      return OrderStatus.ongoing;
    case 'Ready for Pickup':
      return OrderStatus.readyForPickUp;
    case 'Picked up':
      return OrderStatus.pickedUp;
    default:
      return OrderStatus.pending;
  }
}

String getOrderStatusRevered(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Pending';
    case OrderStatus.ongoing:
      return 'Ongoing';
    case OrderStatus.readyForPickUp:
      return 'Ready for Pickup';
    case OrderStatus.pickedUp:
      return 'Picked up';
  }
}

PaymentStatus getPaymentStatus(String status) {
  switch (status) {
    case 'Paid':
      return PaymentStatus.paid;
    case 'Unpaid':
      return PaymentStatus.unpaid;
    default:
      return PaymentStatus.paid;
  }
}

class OrderModel {
  final String order_id;
  final String customer_id;
  final String customerName;
  final int itemsCount;
  final double price;
  final OrderStatus order_status;
  final PaymentStatus payment_status;
  final DateTime date;
  final String? phone_number;

  OrderModel({
    required this.order_id,
    required this.customer_id,
    required this.customerName,
    required this.itemsCount,
    required this.price,
    required this.order_status,
    required this.payment_status,
    required this.date,
    this.phone_number,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      order_id: json['order_id'],
      customer_id: json['customer_id'],
      customerName: json['customer_name'],
      phone_number: json['phone'],
      itemsCount: (json['items'] as List?)?.length ?? 0,
      price: (json['total_price'] as num).toDouble(),
      order_status: getOrderStatus(json['order_status']),
      payment_status: getPaymentStatus(json['payment_status']),
      date: DateTime.parse(json['order_date']),
    );
  }
}
