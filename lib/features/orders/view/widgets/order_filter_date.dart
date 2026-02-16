import 'package:flutter/material.dart';

import 'package:easy_laba/utils/date_formater.dart';

class OrderDateFilter extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const OrderDateFilter({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<StatefulWidget> createState() => _OrderDateFilterStatus();
}

class _OrderDateFilterStatus extends State<OrderDateFilter> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Start Date',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
                    initialDate: widget.startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (result != null) {
                    setState(() {
                      _startDate = result;
                    });
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xFF818181)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      height: 48,
                      padding: EdgeInsets.fromLTRB(42, 8, 8, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formatDateTime('MMMM dd, yyyy', _startDate),
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
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            SizedBox(height: 4),
            Material(
              color: Colors.transparent,
              child: InkWell(
                hoverColor: Colors.transparent,
                onTap: () async {
                  final DateTime? result = await showDatePicker(
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: widget.endDate,
                    context: context,
                    firstDate: widget.startDate,
                    lastDate: DateTime.now(),
                  );

                  if (result != null) {
                    setState(() {
                      _endDate = DateTime(
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
                        border: Border.all(width: 1, color: Color(0xFF818181)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      height: 48,
                      padding: EdgeInsets.fromLTRB(42, 8, 8, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(formatDateTime('MMMM dd, yyyy', _endDate)),
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
                          borderRadius: BorderRadius.all(Radius.circular(5)),
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
                          DateTimeRange(start: _startDate, end: _endDate),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
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
  }
}
