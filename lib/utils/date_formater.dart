import 'package:intl/intl.dart';

String formatDateTime(String format, DateTime date) {
  return DateFormat(format).format(date);
}
