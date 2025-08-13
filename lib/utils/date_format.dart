
import 'package:ets/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Validator {
  static String? emailvalidate(BuildContext context, String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.translate('EMAIL_IS_REQUIED') ?? '';
    }

    return null;
  }
}

DateFormat DynamicDateFormat3 = DateFormat('yyyy-MM-dd');
// using comma
final numberFormat = NumberFormat('#,###');

DateFormat startDateFormate = DateFormat("yyyy-MM-ddT00:00:00.000+00:00");
DateFormat endDateFormate = DateFormat("yyyy-MM-ddT23:59:59.000+00:00");

//
DateFormat AllDynamicDateFormat = DateFormat('dd-MM-yyyy');
DateFormat AllDynamicDateTimeFormat = DateFormat('dd-MM-yyyy h:mm a');
DateFormat LotNumberDateFormat = DateFormat('MMMM d, yyyy');

DateFormat start_date_Format = DateFormat("yyyy-MM-dd'T00:00:00.000+00:00'");
DateFormat end_date_Format = DateFormat("yyyy-MM-dd'T23:59:59.000+00:00'");
DateFormat SelectLotDateFormat = DateFormat('MMMM d yyyy');
DateFormat postDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

DateFormat TimeFormat = DateFormat("hh:mm a");

DateFormat DynamicDateFormat1 = DateFormat("dd-MM-yyyy hh:mm a");
bool isCurrentDate(String dateString) {
  DateTime activityDate = DateTime.parse(dateString);
  DateTime currentDate = DateTime.now();
  return activityDate.year == currentDate.year &&
      activityDate.month == currentDate.month &&
      activityDate.day == currentDate.day;
}

String formatLocalDate(String dateString) {
  try {
    DateTime parsedDate = DateTime.parse(dateString);
    return DateFormat('dd-MM-yyyy hh:mm a').format(parsedDate.toLocal());
  } catch (e) {
    return dateString;
  }
}

String formatLocal(String dateString) {
  try {
    DateTime parsedDate = DateTime.parse(dateString);
    return DateFormat('dd-MM-yyyy').format(parsedDate.toLocal());
  } catch (e) {
    return dateString;
  }
}
