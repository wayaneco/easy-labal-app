import 'package:easy_laba/features/services/model/branch_model.dart';
import 'package:easy_laba/features/services/service/service_service.dart';
import 'package:easy_laba/helpers/capitalize_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class NewOrderSheet extends StatelessWidget {
  const NewOrderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
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
            padding: EdgeInsetsGeometry.all(24),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "Customer",
                  style: TextStyle(color: Color(0xFF1a1a1a), fontWeight: .w500),
                ),
                SizedBox(height: 5),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () async => _showCustomerDialog(context),
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
                          padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Select Customer'),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 8,
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Color(0xFF818181),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Services",
                  style: TextStyle(color: Color(0xFF1a1a1a), fontWeight: .w600),
                ),
                SizedBox(height: 5),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () async => _showServicesDialog(context, []),
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
                          padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Select Services'),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 8,
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Color(0xFF818181),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Payment Method",
                  style: TextStyle(color: Color(0xFF1a1a1a), fontWeight: .w500),
                ),
                SizedBox(height: 5),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () async =>
                        _showPaymentMethodDialog(context, 'gcash'),
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
                          padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Select Payment Method'),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 8,
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Color(0xFF818181),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> _showCustomerDialog(BuildContext context) async {
  return await showAdaptiveDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Customers',
                style: TextStyle(fontWeight: .w500, fontSize: 16),
              ),
              SingleChildScrollView(
                child: Column(children: [Text('James Bond')]),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<List<String>> _showServicesDialog(
  BuildContext context,
  List<String> initialSelectedServices,
) async {
  List<String> selectedService = initialSelectedServices;

  return await showAdaptiveDialog(
    context: context,
    builder: (context) {
      return Consumer<ServiceService>(
        builder: (_, service, child) {
          final serviceItem = service.services;

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Services',
                        style: TextStyle(fontWeight: .w500, fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: serviceItem.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.width / 2),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final serviceId = serviceItem[index].id;
                          final isSelected = selectedService.contains(
                            serviceId,
                          );
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                if (selectedService.contains(serviceId)) {
                                  selectedService.remove(serviceId);
                                } else {
                                  selectedService.add(serviceId);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFdcfce7)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  color: isSelected
                                      ? Color(0xFF00c951)
                                      : Colors.transparent,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFEBEBEB),
                                    spreadRadius: 1,
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              curve: Curves.decelerate,
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment: .start,
                                        children: [
                                          AnimatedDefaultTextStyle(
                                            duration: Duration(
                                              milliseconds: 250,
                                            ),
                                            style: TextStyle(
                                              fontWeight: .w500,
                                              color: Colors.black,
                                            ),

                                            child: Text(
                                              serviceItem[index].name
                                                  .toCapitalized(),
                                            ),
                                          ),
                                          Text(
                                            '₱${serviceItem[index].price.toString()}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      opacity: isSelected ? 1 : 0,
                                      duration: isSelected
                                          ? Duration(milliseconds: 250)
                                          : Duration(milliseconds: 100),
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        size: 24,
                                        color: Color(0xFF00c951),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

Future<String> _showPaymentMethodDialog(
  BuildContext context,
  String initialValue,
) async {
  return await showAdaptiveDialog(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Payment Method',
                style: TextStyle(fontWeight: .w500, fontSize: 16),
              ),
              ListTile(
                selected: initialValue == 'cash',
                leading: Radio(
                  value: 'cash',
                  groupValue: initialValue,
                  onChanged: (_) {
                    Navigator.pop(context, 'cash');
                  },
                ),
                onTap: () {
                  Navigator.pop(context, 'cash');
                },
                title: Text('Cash'),
              ),
              ListTile(
                selected: initialValue == 'gcash',
                leading: Radio(
                  value: 'gcash',
                  groupValue: initialValue,
                  onChanged: (_) {
                    Navigator.pop(context, 'gcash');
                  },
                ),
                onTap: () {
                  Navigator.pop(context, 'gcash');
                },
                title: Text('GCash'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
