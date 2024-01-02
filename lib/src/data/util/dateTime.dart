import 'package:intl/intl.dart';

DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

String dateTimeToString(DateTime dateTime) {
  return _dateFormat.format(dateTime);
}

DateTime stringToDateTime(String str) {
  return _dateFormat.parse(str);
}
