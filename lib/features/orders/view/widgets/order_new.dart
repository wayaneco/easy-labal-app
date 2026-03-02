import 'package:easy_laba/features/customers/model/customer_model.dart';
import 'package:easy_laba/features/customers/service/customer_service.dart';
import 'package:easy_laba/features/services/service/service_service.dart';
import 'package:easy_laba/helpers/capitalize_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewOrderSheet extends StatefulWidget {
  const NewOrderSheet({super.key});

  @override
  State<NewOrderSheet> createState() => _NewOrderSheetState();
}

class _NewOrderSheetState extends State<NewOrderSheet>
    with SingleTickerProviderStateMixin {
  String? _selectedCustomer;
  List<String> _selectedServices = [];
  String? _selectedPaymentMethod = 'cash';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<CustomerModel> customers = context.watch<CustomerService>().customers;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(colorScheme),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildCustomerField(context, colorScheme, customers),
                  const SizedBox(height: 20),
                  _buildServicesField(context, colorScheme),
                  const SizedBox(height: 20),
                  _buildPaymentMethodField(context, colorScheme),
                  const SizedBox(height: 32),
                  _buildSubmitButton(context, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create New Order',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1a1a1a),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Fill in the details below to create a new order',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildCustomerField(
    BuildContext context,
    ColorScheme colorScheme,
    List<CustomerModel> customers,
  ) {
    return _buildFormField(
      context,
      label: 'Customer',
      hintText: _selectedCustomer != null
          ? customers
                .singleWhere((customer) => customer.id == _selectedCustomer)
                .fullName
                .toCapitalized()
          : 'Select Customer',
      icon: Icons.person_outline_rounded,
      isSelected: _selectedCustomer != null,
      colorScheme: colorScheme,
      onTap: () async {
        final String? result = await _showCustomerDialog(
          context,
          customers,
          _selectedCustomer,
        );

        if (result != null) {
          setState(() {
            _selectedCustomer = result;
          });
        }
      },
    );
  }

  Widget _buildServicesField(BuildContext context, ColorScheme colorScheme) {
    final serviceCount = _selectedServices.length;
    return _buildFormField(
      context,
      label: 'Services',
      hintText: serviceCount > 0
          ? '$serviceCount service${serviceCount > 1 ? "s" : ""} selected'
          : 'Select Services',
      icon: Icons.cleaning_services_outlined,
      isSelected: _selectedServices.isNotEmpty,
      colorScheme: colorScheme,
      onTap: () async {
        final result = await _showServicesDialog(context, _selectedServices);
        if (result != null) {
          setState(() => _selectedServices = result);
        }
      },
    );
  }

  Widget _buildPaymentMethodField(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return _buildFormField(
      context,
      label: 'Payment Method',
      hintText: _selectedPaymentMethod == 'cash'
          ? 'Cash'
          : _selectedPaymentMethod == 'gcash'
          ? 'GCash'
          : 'Select Payment Method',
      icon: Icons.payment_outlined,
      isSelected: _selectedPaymentMethod != null,
      colorScheme: colorScheme,
      onTap: () async {
        final result = await _showPaymentMethodDialog(
          context,
          _selectedPaymentMethod ?? 'cash',
        );
        if (result != null) {
          setState(() => _selectedPaymentMethod = result);
        }
      },
    );
  }

  Widget _buildFormField(
    BuildContext context, {
    required String label,
    required String hintText,
    required IconData icon,
    required bool isSelected,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colorScheme.primary : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? colorScheme.primary
                    : const Color(0xFF1a1a1a),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.05)
                    : Colors.white,
                border: Border.all(
                  width: isSelected ? 2 : 1,
                  color: isSelected
                      ? colorScheme.primary
                      : const Color(0xFFE5E7EB),
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hintText,
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.primary
                            : const Color(0xFF6B7280),
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isSelected ? 0.25 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isSelected
                          ? colorScheme.primary
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, ColorScheme colorScheme) {
    final isEnabled =
        _selectedCustomer != null &&
        _selectedServices.isNotEmpty &&
        _selectedPaymentMethod != null;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: isEnabled
            ? () {
                // Handle submit
                Navigator.of(context).pop({
                  'customer': _selectedCustomer,
                  'services': _selectedServices,
                  'paymentMethod': _selectedPaymentMethod,
                });
              }
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          disabledBackgroundColor: const Color(0xFFE5E7EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isEnabled) ...[
              const Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              isEnabled ? 'Create Order' : 'Complete all fields',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isEnabled ? Colors.white : const Color(0xFF9CA3AF),
              ),
            ),
            if (isEnabled) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

Future<String?> _showCustomerDialog(
  BuildContext context,
  List<CustomerModel> customers,
  String? selectedCustomerId,
) async {
  final TextEditingController searchController = TextEditingController();
  return await showModalBottomSheet<String>(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          final filteredCustomers = customers
              .where(
                (customer) => customer.fullName.toString().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Select Customer',
                            style: Theme.of(dialogContext).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: searchController,
                        onChanged: (_) {
                          setModalState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search customer',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFFebebeb),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                filteredCustomers.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
                          itemBuilder: (context, index) => _buildCustomerItem(
                            dialogContext,
                            customerId: filteredCustomers[index].id,
                            name: filteredCustomers[index].fullName,
                            phone: filteredCustomers[index].phone,
                            selectedCustomerId: selectedCustomerId,
                            onTap: () => Navigator.of(
                              dialogContext,
                            ).pop(filteredCustomers[index].id),
                          ),
                          separatorBuilder: (_, __) => SizedBox(height: 8),
                          itemCount: filteredCustomers.length,
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: .center,
                          children: [
                            Icon(Icons.tab),
                            Text('Cannot find what you looking for'),
                          ],
                        ),
                      ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildCustomerItem(
  BuildContext context, {
  required String customerId,
  required String name,
  required String phone,
  required VoidCallback onTap,
  String? selectedCustomerId,
}) {
  final bool isSelected = customerId == selectedCustomerId;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF10B981)
                : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
              child: Text(
                name.substring(0, 1),
                style: const TextStyle(
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    phone,
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              // Icons.arrow_forward_ios_rounded,
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: isSelected ? 24 : 16,
              color: Color(isSelected ? 0xFF10B981 : 0xFF9CA3AF),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<List<String>?> _showServicesDialog(
  BuildContext context,
  List<String> initialSelectedServices,
) async {
  List<String> selectedServices = List.from(initialSelectedServices);

  return await showModalBottomSheet<List<String>>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (dialogContext) {
      return Consumer<ServiceService>(
        builder: (_, service, child) {
          final serviceItem = service.services;

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * 0.75,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
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
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.cleaning_services_outlined,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Select Services',
                          style: Theme.of(dialogContext).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${selectedServices.length} selected',
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: serviceItem.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final serviceId = serviceItem[index].id;
                      final isSelected = selectedServices.contains(serviceId);

                      return _buildServiceCard(
                        dialogContext,
                        name: serviceItem[index].name.toCapitalized(),
                        price: '₱${serviceItem[index].price.toString()}',
                        isSelected: isSelected,
                        onTap: () {
                          if (selectedServices.contains(serviceId)) {
                            selectedServices.remove(serviceId);
                          } else {
                            selectedServices.add(serviceId);
                          }
                          (dialogContext as Element).markNeedsBuild();
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: selectedServices.isNotEmpty
                          ? () => Navigator.of(
                              dialogContext,
                            ).pop(selectedServices)
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        disabledBackgroundColor: const Color(0xFFE5E7EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Confirm Selection (${selectedServices.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selectedServices.isNotEmpty
                              ? Colors.white
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildServiceCard(
  BuildContext context, {
  required String name,
  required String price,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: isSelected
                ? const Color(0xFF10B981)
                : const Color(0xFFE5E7EB),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.cleaning_services_rounded,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isSelected
                          ? const Color(0xFF065F46)
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<String?> _showPaymentMethodDialog(
  BuildContext context,
  String initialValue,
) async {
  return await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (dialogContext) {
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.payment_outlined,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Payment Method',
                        style: Theme.of(dialogContext).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentOption(
                    dialogContext,
                    value: 'cash',
                    groupValue: initialValue,
                    label: 'Cash',
                    icon: Icons.money_rounded,
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentOption(
                    dialogContext,
                    value: 'gcash',
                    groupValue: initialValue,
                    label: 'GCash',
                    icon: Icons.account_balance_wallet_rounded,
                    color: const Color(0xFF0077B5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPaymentOption(
  BuildContext context, {
  required String value,
  required String groupValue,
  required String label,
  required IconData icon,
  required Color color,
}) {
  final isSelected = value == groupValue;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => Navigator.of(context).pop(value),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.white,
          border: Border.all(
            width: 1,
            color: isSelected ? color : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isSelected ? color : const Color(0xFF1a1a1a),
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 24),
          ],
        ),
      ),
    ),
  );
}
