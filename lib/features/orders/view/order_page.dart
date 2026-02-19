import 'package:easy_laba/utils/date_formater.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:easy_laba/components/drawer.dart';

import 'package:easy_laba/features/orders/view/widgets/order_status_filter.dart';
import 'package:easy_laba/features/orders/view/widgets/order_filter_date.dart';
import 'package:easy_laba/features/orders/view/widgets/order_details.dart';
import 'package:easy_laba/features/orders/view/widgets/order_new.dart';
import 'package:easy_laba/features/orders/view/widgets/order_card.dart';

import '../service/order_service.dart';
import '../model/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

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
      case OrderStatus.all:
        return '';
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
      case OrderStatus.all:
        return Icons.done;
    }
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetail(order: order),
    );
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog(
      context: context,
      builder: (_) => OrderStatusFilter(selectedStatus: _selectedStatusFilter),
    );

    if (result != null) {
      setState(() {
        _selectedStatusFilter = result == OrderStatus.all ? null : result;
      });

      fetchOrders();
    }
  }

  void _showNewOrder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewOrderSheet(),
    );
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
        return OrderDateFilter(startDate: startDate, endDate: endDate);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    orders = OrderService().fetchOrders(date: dateRangeFilter);
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
                      return OrderCard(
                        order: data[index],
                        statusColor: _getStatusColor(data[index].order_status),
                        statusText: _getStatusText(data[index].order_status),
                        statusIcon: _getStatusIcon(data[index].order_status),
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
          tooltip: 'Date Filter',
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
            formatDateTime('MMMM dd, yyyy', dateRangeFilter.start),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('to'),
          Text(
            formatDateTime('MMMM dd, yyyy', dateRangeFilter.end),
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
}
