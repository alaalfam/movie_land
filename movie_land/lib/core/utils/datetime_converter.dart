import 'package:intl/intl.dart';

class DatetimeConverter {
  String convertToReadableDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return dateString; // Return the original string if parsing fails
    }
  }

  String convertToHumanReadable(String dateString) {
    DateTime? parsedDate = DateTime.tryParse(dateString);

    // Format the date in the required format
    if (parsedDate == null) {
      return dateString;
    } else {
      String formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
      return formattedDate;
    }
  }
}
