import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:easy_laba/components/drawer.dart';

import '../service/order.service.dart';

import '../models/order.model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderStatus? _selectedStatusFilter;
  final TextEditingController _searchQuery = TextEditingController();
  Future<List<OrderModel>>? orders;
  DateTimeRange dateRangeFilter = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
    ),
  );

  Timer? _debounce;

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF59E0B);
      case OrderStatus.ongoing:
        return const Color(0xFF3B82F6);
      case OrderStatus.pickedUp:
        return const Color(0xFF10B981);
      case OrderStatus.readyForPickUp:
        return const Color(0xFFEF4444);
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.ongoing:
        return 'Processing';
      case OrderStatus.pickedUp:
        return 'Completed';
      case OrderStatus.readyForPickUp:
        return 'Ready For Pickup';
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.ongoing:
        return Icons.sync;
      case OrderStatus.pickedUp:
        return Icons.check_circle;
      case OrderStatus.readyForPickUp:
        return Icons.done_all;
    }
  }

  String _formatDateTime(String format, DateTime date) {
    return DateFormat(format).format(date);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OrderDetailsSheet(order: order),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
        title: const Text('Filter Orders'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              selected: _selectedStatusFilter == null,
              title: const Text('All'),
              leading: Radio<OrderStatus?>(
                value: null,
                groupValue: _selectedStatusFilter,
                onChanged: (value) {
                  setState(() => _selectedStatusFilter = value);
                  fetchOrders();
                  Navigator.pop(context);
                },
              ),
              trailing: null,
            ),
            ...OrderStatus.values.map(
              (status) => ListTile(
                selected: _selectedStatusFilter == status,
                title: Text(_getStatusText(status)),
                leading: Radio<OrderStatus?>(
                  value: status,
                  groupValue: _selectedStatusFilter,
                  onChanged: (value) {
                    setState(() => _selectedStatusFilter = value);
                    fetchOrders();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewOrder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_context) => _NewOrderSheet(),
    );
  }

  @override
  void initState() {
    super.initState();

    orders = OrderService().fetchOrders(date: dateRangeFilter);
  }

  void fetchOrders() {
    setState(() {
      orders = OrderService().fetchOrders(
        search: _searchQuery.text.isNotEmpty ? _searchQuery.text : null,
        orderStatus: _selectedStatusFilter,
        date: dateRangeFilter,
      );
    });
  }

  Future<DateTimeRange?> _selectDate(
    BuildContext context,
    DateTime initialStartDate,
    DateTime initialEndDate,
  ) async {
    DateTime? startDate = initialStartDate;
    DateTime? endDate = initialEndDate;

    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: AlignmentGeometry.center,
                      child: Text(
                        'Select Date Range',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Start Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () async {
                          final DateTime? result = await showDatePicker(
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );

                          if (result != null) {
                            setState(() {
                              startDate = result;
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xFF818181),
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              height: 48,
                              padding: EdgeInsets.fromLTRB(42, 8, 8, 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  startDate == null
                                      ? 'mm/dd/yyyy'
                                      : DateFormat(
                                          'MMMM dd, yyyy',
                                        ).format(startDate!),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 8,
                              child: Icon(
                                Icons.calendar_month,
                                color: Color(0xFF818181),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'End Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () async {
                          final DateTime? result = await showDatePicker(
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            initialDate: startDate,
                            context: context,
                            firstDate: startDate!,
                            lastDate: DateTime.now(),
                          );

                          if (result != null) {
                            setState(() {
                              endDate = DateTime(
                                result.year,
                                result.month,
                                result.day,
                                23,
                                59,
                                59,
                              );
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xFF818181),
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              height: 48,
                              padding: EdgeInsets.fromLTRB(42, 8, 8, 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  endDate == null
                                      ? 'mm/dd/yyyy'
                                      : DateFormat(
                                          'MMMM dd, yyyy',
                                        ).format(endDate!),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 8,
                              child: Icon(
                                Icons.calendar_month,
                                color: Color(0xFF818181),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      spacing: 18,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                              child: Text('Cancel'),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(
                                  context,
                                  DateTimeRange(
                                    start: startDate!,
                                    end: endDate!,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3B82F6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: CustomDrawer(),
      appBar: _buildAppBar(context),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildSearchBar(),
          _buildDateRangeInfo(),
          Expanded(
            child: FutureBuilder<List<OrderModel>>(
              initialData: [],
              future: orders,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        constraints: BoxConstraints(),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final data = snapshot.data!;

                if (data.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  child: ListView.separated(
                    itemCount: data.length,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _OrderCard(
                        order: data[index],
                        statusColor: _getStatusColor(data[index].order_status),
                        statusText: _getStatusText(data[index].order_status),
                        statusIcon: _getStatusIcon(data[index].order_status),
                        formatDate: _formatDate,
                        onTap: () => _showOrderDetails(data[index]),
                      );
                    },
                  ),
                  onRefresh: () async {
                    setState(() {
                      orders = OrderService().fetchOrders();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewOrder,
        backgroundColor: const Color(0xFF3B82F6),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Order',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3B82F6),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: _showFilterDialog,
          tooltip: 'Filter',
        ),
        IconButton(
          onPressed: () async {
            final result = await _selectDate(
              context,
              dateRangeFilter.start,
              dateRangeFilter.end,
            );

            if (result != null) {
              setState(() {
                dateRangeFilter = result;
              });

              fetchOrders();
            }
          },
          icon: Icon(Icons.calendar_month_outlined, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchQuery,
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  _debounce = Timer(const Duration(milliseconds: 1000), () {
                    fetchOrders();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search orders or customers...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF94A3B8),
                  ),
                  suffixIcon: _searchQuery.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xFF94A3B8),
                          ),
                          onPressed: () {
                            setState(() => _searchQuery.text = '');
                            fetchOrders();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text('Showing'),
          Text(
            _formatDateTime('MMMM dd, yyyy', dateRangeFilter.start),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('to'),
          Text(
            _formatDateTime('MMMM dd, yyyy', dateRangeFilter.end),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox, size: 48, color: Color(0xFF3B82F6)),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.text.isNotEmpty
                ? 'Try adjusting your search'
                : 'Create your first order to get started',
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // Widget _buildOrdersList() {
  //   return RefreshIndicator(
  //     onRefresh: () async {
  //       await Future.delayed(const Duration(seconds: 1));
  //     },
  //     child: ListView.separated(
  //       padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
  //       itemCount: _filteredOrders.length,
  //       separatorBuilder: (_, __) => const SizedBox(height: 12),
  //       itemBuilder: (context, index) {
  //         final order = _filteredOrders[index];
  //         return _OrderCard(
  //           order: order,
  //           statusColor: _getStatusColor(order.order_status),
  //           statusText: _getStatusText(order.order_status),
  //           statusIcon: _getStatusIcon(order.order_status),
  //           formatDate: _formatDate,
  //           onTap: () => _showOrderDetails(order),
  //         );
  //       },
  //     ),
  //   );
  // }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final Color statusColor;
  final String statusText;
  final IconData statusIcon;
  final String Function(DateTime) formatDate;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.statusColor,
    required this.statusText,
    required this.statusIcon,
    required this.formatDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.order_id,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.customerName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, size: 14, color: statusColor),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.inventory_2_outlined,
                        label: '${order.itemsCount} items',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.access_time,
                        label: formatDate(order.date),
                      ),
                      const Spacer(),
                      Text(
                        '₱${order.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF475569),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDetailsSheet extends StatelessWidget {
  final OrderModel order;

  const _OrderDetailsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                        Icons.local_laundry_service,
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
                            order.customerName,
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
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

class _NewOrderSheet extends StatelessWidget {
  const _NewOrderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [Text("Hello")]),
    );
  }
}
