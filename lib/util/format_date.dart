import 'package:intl/intl.dart';

String handleFormatDate(date) {
  if (date != null) {
    try {
      // Attempt to parse the date string
      DateTime dateTime = DateTime.parse(date);
      // Format the parsed date
      String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      // If parsing fails, return an empty string or handle the error as needed
      print("Error parsing date: $e");
      return "";
    }
  } else {
    return "";
  }
}
