/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

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
