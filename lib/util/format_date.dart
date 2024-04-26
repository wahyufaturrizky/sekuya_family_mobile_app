import 'package:intl/intl.dart';

String handleFormatDate(date) {
  String originalDateString = date;
  DateTime dateTime = DateTime.parse(originalDateString);
  String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);

  return formattedDate;
}
