import 'package:intl/intl.dart';

DateFormat formatDateTimeMinutes = DateFormat('yyyy-MM-dd HH:mm');
DateFormat formatDateTimeSeconds = DateFormat('yyyy-MM-dd HH:mm:ss');
DateFormat formatTimeReadable = DateFormat('HH:mm');

DateTime? stringToDateTimeNullable(String? str, DateFormat dateFormat) {
  if (str == null) {
    return null;
  } else {
    return dateFormat.parse(str);
  }
}
