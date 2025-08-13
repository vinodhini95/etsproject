
import 'package:ets/dynamic_widget/app_elevator_button.dart';
import 'package:ets/dynamic_widget/apptext_formfield.dart';
import 'package:ets/utils/color.dart';
import 'package:ets/utils/date_format.dart';
import 'package:ets/utils/localization.dart';
import 'package:ets/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Helper {
// Dialog

  String getFormattedTime(dynamic input) {
    DateTime date;

    if (input is String) {
      try {
        date = DateTime.parse(input).toLocal();
      } catch (e) {
        return 'Invalid date format';
      }
    } else if (input is DateTime) {
      date = input;
    } else {
      return 'Unsupported type';
    }

    return DynamicDateFormat1.format(date);
  }

  String getFormattedTime1(dynamic input) {
    DateTime date;

    if (input is String) {
      try {
        date = DateTime.parse(input);
      } catch (e) {
        return 'Invalid date format';
      }
    } else if (input is DateTime) {
      date = input;
    } else {
      return 'Unsupported type';
    }

    return DynamicDateFormat1.format(date);
  }

  // date filter
  void showGradingDialog(
      BuildContext context,
      String equipmentType,
      dynamic currentdatelist,
      List<dynamic> lotlist,
      GlobalKey<FormState> _formKey,
      TextEditingController _startDateController,
      TextEditingController _endDateController,
      void Function()? onStarDateTab,
      String? Function(String?)? StartDatevalidator,
      void Function()? onEndDateTab,
      String? Function(String?)? endDatevalidator,
      void Function()? onTab) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date Filter",
                            style: loderTextStyle2.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      AppTextFormField(
                        isRequired: false,
                        controller: _startDateController,
                        readOnly: true,
                        labelText: "Start Date",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        suffixIcon: Icons.calendar_today,
                        suffixIconOnTap: onStarDateTab,
                        validator: StartDatevalidator,
                      ),
                      SizedBox(height: 10),
                      AppTextFormField(
                        isRequired: false,
                        controller: _endDateController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                        labelText: "End Date",
                        suffixIcon: Icons.calendar_today,
                        suffixIconOnTap: onEndDateTab,
                        validator: endDatevalidator,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                        child: AppEllevatedAuthButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            btnName: "Cancel",
                            textColor:
                                Theme.of(context).colorScheme.surfaceTint,
                            primaryColor: Theme.of(context).colorScheme.surface,
                            iconIsrequired: false)),
                    SizedBox(width: 8),
                    Flexible(
                      child: AppEllevatedAuthButton(
                        iconIsrequired: false,
                        primaryColor: Theme.of(context).colorScheme.primary,
                        onPressed: onTab,
                        btnName: "Show",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showGradingDialog1(
      BuildContext context,
      GlobalKey<FormState> _formKey,
      TextEditingController _startDateController,
      TextEditingController _endDateController,
      void Function()? onStarDateTab,
      String? Function(String?)? StartDatevalidator,
      void Function()? onEndDateTab,
      String? Function(String?)? endDatevalidator,
      void Function()? onTab) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date Filter",
                            style: loderTextStyle2.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      AppTextFormField(
                        isRequired: false,
                        controller: _startDateController,
                        readOnly: true,
                        labelText: "Start Date",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        suffixIcon: Icons.calendar_today,
                        suffixIconOnTap: onStarDateTab,
                        validator: StartDatevalidator,
                      ),
                      SizedBox(height: 10),
                      AppTextFormField(
                        isRequired: false,
                        controller: _endDateController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                        labelText: "End Date",
                        suffixIcon: Icons.calendar_today,
                        suffixIconOnTap: onEndDateTab,
                        validator: endDatevalidator,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                        child: AppEllevatedAuthButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            btnName: "Cancel",
                            textColor:
                                Theme.of(context).colorScheme.surfaceTint,
                            primaryColor: Theme.of(context).colorScheme.surface,
                            iconIsrequired: false)),
                    SizedBox(width: 8),
                    Flexible(
                      child: AppEllevatedAuthButton(
                        iconIsrequired: false,
                        onPressed: onTab,
                        primaryColor: Theme.of(context).colorScheme.primary,
                        btnName: "Show",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //compare dates
  // compareDates(BuildContext context, DateTime selectedDate) {
  //   var selectedFactoryProcess =
  //       context.read<GradingProvider>().getFactoryProcess;
  //   var date_extend = selectedFactoryProcess.isNotEmpty
  //       ? selectedFactoryProcess[0]["editable_allowed_days"]
  //       : 0;
  //   final date = selectedDate.toLocal();
  //   final now = DateTime.now();
  //   Duration difference = now.difference(date);
  //   if (difference.inDays <= date_extend) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  //Open Awesome dialogue box
  openAwesomeDialgue(BuildContext context, DialogType dialogType,
      String description, dynamic Function()? btnOkOnPress) {
    Color btnOkColor;
    switch (dialogType) {
      case DialogType.warning:
        btnOkColor = const Color(0xFFFEB800);
        break;
      case DialogType.success:
        btnOkColor = const Color(0xFF00CA71);
        break;
      case DialogType.error:
        btnOkColor = const Color(0xFFD93E47);
        break;
      case DialogType.info:
        btnOkColor = const Color(0xFF0098FF);
        break;
      case DialogType.question:
        btnOkColor = const Color.fromARGB(255, 255, 94, 0);
        break;
      default:
        btnOkColor = Colors.black12;
    }

    return AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.rightSlide,
      descTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      desc: description,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      btnOkText: "OK",
      btnOkColor: btnOkColor,
      btnOkOnPress: btnOkOnPress,
    )..show();
  }

  openAwesomeDialgue1(
      BuildContext context,
      DialogType dialogType,
      String description,
      dynamic Function()? btnOkOnPress,
      dynamic Function()? btnCancelOnPress,
      String? titl,
      String? btnOkText) {
    return AwesomeDialog(
      context: context,
      dialogType: dialogType,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      title: titl != null && titl.isNotEmpty ? titl : null,
      animType: AnimType.rightSlide,
      titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      descTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      desc: description,
      btnOkText: btnOkText!.isEmpty ? "OK" : btnOkText,
      btnOkOnPress: btnOkOnPress,
      btnCancelText: "Cancel",
      btnCancelOnPress: btnCancelOnPress,
    )..show();
  }

  Color hashToHex(String hashString) {
    final buffer = StringBuffer();
    if (hashString.length == 6 || hashString.length == 7) buffer.write('ff');
    buffer.write(hashString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'email':
        return Icons.email;
      case 'person':
        return Icons.person;
      case 'visibility':
        return Icons.visibility;
      case 'visibility_off':
        return Icons.visibility_off;
      case 'barcode':
        return Icons.qr_code_scanner;
      default:
        return Icons.error;
    }
  }

  showTostMessage(String? errorMessage) {
    Fluttertoast.showToast(
        msg: "$errorMessage",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: buttonColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  DateTime getFormattedDateTime(dynamic input) {
    DateTime date;

    if (input is String) {
      try {
        date = DateTime.parse(input);
      } catch (e) {
        return DateTime.now();
      }
    } else if (input is DateTime) {
      date = input;
    } else {
      return DateTime.now();
    }

    return date;
  }

  // String getDuration(String startTime, String endTime) {
  //   DateTime start = DateTime.parse(startTime);
  //   DateTime end = DateTime.parse(endTime);
  //   Duration duration = end.difference(start);
  //   String formattedDuration =
  //       '${duration.inHours} hr ${duration.inMinutes.remainder(60)} min';
  //   return formattedDuration;
  // }
  String getDuration(String startTime, String endTime) {
    DateTime time1 = DateTime.parse(startTime);
    DateTime time2 = DateTime.parse(endTime).toLocal();
    ;

    String formattedTime1 =
        time1.toUtc().toIso8601String().split(".")[0] + ".000Z";
    String formattedTime2 = time2.toIso8601String().split(".")[0] + ".000Z";

    String startTime1 = formattedTime1;
    String currentTime = formattedTime2;

    DateTime tt = DateTime.parse(startTime1).toUtc();
    DateTime ttt = DateTime.parse(currentTime).toUtc();
    int mm = ttt.difference(tt).inMinutes;
    int hr = ttt.difference(tt).inHours;

    return "${hr.toString()} hrs  - ${mm.toString()} min ";
  }

  String getTotalDuration(String cycleOneStart, String cycleOneEnd,
      String cycleTwoStart, String cycleTwoEnd) {
    // Parse the start and end times for each cycle
    DateTime cycleOneStartTime = DateTime.parse(cycleOneStart);
    DateTime cycleOneEndTime = DateTime.parse(cycleOneEnd);
    DateTime cycleTwoStartTime = DateTime.parse(cycleTwoStart);
    DateTime cycleTwoEndTime = DateTime.parse(cycleTwoEnd);

    // Calculate the duration for each cycle
    Duration cycleOneDuration = cycleOneEndTime.difference(cycleOneStartTime);
    Duration cycleTwoDuration = cycleTwoEndTime.difference(cycleTwoStartTime);

    // Sum the durations
    Duration totalDuration = cycleOneDuration + cycleTwoDuration;

    // Format the total duration
    String formattedDuration =
        '${totalDuration.inHours} hours ${totalDuration.inMinutes.remainder(60)} minutes';

    return formattedDuration;
  }

  String getISTTime(String dateTimeString) {
    // Parse the given DateTime string
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime dateTimeIST = dateTime.add(Duration(hours: 5, minutes: 30));

    DateFormat timeFormat = TimeFormat;
    String formattedTime = timeFormat.format(dateTimeIST);

    return formattedTime;
  }

  String getFormattedTimes(dynamic input) {
    DateTime time;

    if (input is String) {
      try {
        time = DateTime.parse(input);
      } catch (e) {
        return 'Invalid time format';
      }
    } else if (input is DateTime) {
      time = input;
    } else {
      return 'Unsupported type';
    }

    return TimeFormat.format(time);
  }

  String generateUID() {
    var uuid = const Uuid();

    return uuid.v4();
  }

  String getFormattedTimess(String date) {
    final dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy h a').format(dateTime);
  }

  // Calculate the time difference
  String calculateTimeDifference(String date) {
    print(date);
    final scheduledDateTime = DateTime.parse(date);
    final currentDateTime = DateTime.now();

    // Calculate the difference
    final duration = scheduledDateTime.difference(currentDateTime);

    final isPast = duration.isNegative;
    final durationAbs = duration.abs();

    // Calculate days, hours, and minutes
    final days = durationAbs.inDays;
    final hours = durationAbs.inHours % 24;
    final minutes = durationAbs.inMinutes % 60;

    // Build the time difference string
    final timeDifference = StringBuffer();
    if (days > 0) timeDifference.write('$days day${days > 1 ? 's' : ''} ');
    if (hours > 0) timeDifference.write('$hours hr${hours > 1 ? 's' : ''} ');
    if (minutes > 0)
      timeDifference.write('$minutes min${minutes > 1 ? 's' : ''}');

    // Trim any extra spaces
    final formattedDifference = timeDifference.toString().trim();

    if (isPast) {
      return formattedDifference.isNotEmpty
          ? '$formattedDifference delayed'
          : 'Just now';
    } else {
      return formattedDifference.isNotEmpty
          ? '$formattedDifference'
          : 'Just now';
    }
  }

  String calculateDelay(String scheduledDate, String processEndDateTime) {
  // Parse both with full datetime
  DateTime scheduledDateTime = DateTime.parse(scheduledDate).toLocal();
  DateTime processEndDateTimeObj = DateTime.parse(processEndDateTime).toUtc();
  int days = scheduledDateTime.day;
  int hours = scheduledDateTime.hour % 24;
  int minutes = scheduledDateTime.minute % 60;
 
  int processdays = processEndDateTimeObj.day;
  int processhours = processEndDateTimeObj.hour % 24;
  int processminutes = processEndDateTimeObj.minute % 60;
  String timeString = '';

  int differencedays = processdays - days;
  int differencehours = processhours - hours;
  int differenceminutes = processminutes - minutes;
  if (differencedays > 0) {
    timeString += '$differencedays day${differencedays > 1 ? 's' : ''} ';
  }
  if (differencehours > 0) {
    timeString += '$differencehours hr${differencehours > 1 ? 's' : ''} ';
  }
  if (differenceminutes > 0) {
    timeString += '$differenceminutes min${differenceminutes > 1 ? 's' : ''}';
  }

  return '$timeString Delay';
}


  String getFormattedDate(String input, String type) {
    var date;
    var parseDate;

    try {
      parseDate = DateTime.parse(input);
    } catch (e) {
      print(e);
    }

    if (type == "Date") {
      try {
        date = parseDate != null
            ? DynamicDateFormat3.format(parseDate)
            : DynamicDateFormat3.format(DateTime.now());
      } catch (e) {
        print(e);
      }
    } else if (type == "DateTime") {
      date = postDateFormat.format(parseDate);
    }

    return date;
  }

  String getCurrentDateTime() {
    final DateTime now = DateTime.now();
    return DateFormat('dd-MM-yyyy - hh:mm a').format(now);
  }

  calculateMiniteDuration(BuildContext context, String startTime,
      String equipmentType, List<dynamic> listData, bool isMintsisthere) {
    if (listData.isNotEmpty) {
      var currentDateTime = DateTime.now();

      DateTime time1 = DateTime.parse(startTime).toLocal();
      DateTime time2 = currentDateTime;

      int mm = time2.difference(time1).inMinutes;

      var cookerList =
          listData.where((element) => element["_id"] == equipmentType).toList();
      var minimumduration = isMintsisthere
          ? listData[0]["duration"]
          : cookerList.isEmpty
              ? 0
              : cookerList[0]["minimum_duration"] ?? 0;
      // return 10;
      return mm < minimumduration ? minimumduration - mm : 0;
    }
    return 0;
  }

  //get Text field
  getTextField(BuildContext context, String textField, TextStyle textStyle) {
    return Text(
      AppLocalizations.of(context)!.translate(textField) ?? '',
      style: textStyle,
    );
  }

  //get Text field
  getTextFieldWioutTransulator(
      BuildContext context, String textField, TextStyle textStyle) {
    return Text(
      textField,
      style: textStyle,
    );
  }

  //get rich text
  getRichText(BuildContext context, String textField1, String textField2) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: textField1, style: viewTextStyle),
          TextSpan(text: textField2, style: viewTextStyle1),
        ],
      ),
    );
  }

  // //dianamic datePicker
  // selectDatePicker(BuildContext context) {
  //   var selectedFactoryProcess =
  //       context.read<GradingProvider>().getFactoryProcess;
  //   DateTime now = DateTime.now();
  //   DateTime lastDate = now;
  //   DateTime currentDate = selectedFactoryProcess.isNotEmpty
  //       ? now.subtract(
  //           Duration(days: selectedFactoryProcess[0]["back_log_days"]))
  //       : now.subtract(Duration(days: 6));
  //   return showDatePicker(
  //     context: context,
  //     initialDate: lastDate,
  //     firstDate: currentDate,
  //     lastDate: lastDate,
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           primaryColor: Theme.of(context).colorScheme.primary,
  //           hintColor: Theme.of(context).colorScheme.primary,
  //           colorScheme: ColorScheme.light(
  //               primary: Theme.of(context).colorScheme.primary),
  //           buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  // }

  selectDatePicker1(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      // initialDate: DateTime.now(),
      // firstDate: DateTime.now().subtract(Duration(days: 6)),
      // lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: buttonColor,
            hintColor: buttonColor,
            colorScheme: ColorScheme.light(primary: buttonColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

  //Calculate Total Output
  num calculategradeInput(List<dynamic> items) {
    return items.fold(0, (sum, item) {
      final output = item['input_weight'] as num?;
      return sum + (output ?? 0);
    });
  }

//Calculate Total Output
  num calculatePacking(List<dynamic> items) {
    return items.fold(0, (sum, item) {
      final output = item['input_weight'] as num?;
      return sum + (output ?? 0);
    });
  }

  //Calculate Total Output
  num calculateTotalOutput(List<dynamic> items) {
    return items.fold(0, (sum, item) {
      // final output = item['output_weight'] as num?;
      final output = item['output_weight'] as num?;
      return sum + (output ?? 0);
    });
  }

  num calculateTotal(List<dynamic> items, String fieldName) {
    return items.fold(0, (sum, item) {
      // final output = item['output_weight'] as num?;
      final output = item[fieldName] as num?;

      return sum + (output ?? 0);
    });
  }

  num calculateJobworkweight(List<dynamic> items) {
    return items.fold(0, (sum, item) {
      // final output = item['output_weight'] as num?;
      final output = item['weight'] as num?;

      return sum + (output ?? 0);
    });
  }

  //Calculate Total count
  num calculatebormaTotalCount(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) {
      final output = item['total_count'] as num?;
      return sum + (output ?? 0);
    });
  }

  //Calculate Total count
  num calculatebormaTotalwholesCount(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) {
      final output = item['Wholes'] as num?;
      return sum + (output ?? 0);
    });
  }

  num calculatebormaTotalpiecesCount(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) {
      final output = item['Pieces'] as num?;
      return sum + (output ?? 0);
    });
  }

  num calculatebormaTotalRejectedCount(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) {
      final output = item['Rejected'] as num?;
      return sum + (output ?? 0);
    });
  }

  num calculatebormaTotalUncutCount(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) {
      final output = item['uncut'] as num?;
      return sum + (output ?? 0);
    });
  }

  num calculatebormaTotalShellCount(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) {
      final output = item['shell'] as num?;
      return sum + (output ?? 0);
    });
  }

  // hexa To Color Code converter

  int hexaToColorCode(String hexColor) {
    int color = int.parse(hexColor.replaceFirst('#', '0xff'));
    return color;
  }

  // Dialog
  void openDialog(
      {required BuildContext context,
      String? btnCancelText,
      bool? btnCancelShow,
      Function()? btnCancelOnPress,
      required String desc,
      String? btnOkText,
      required DialogType dialogType,
      required String title,
      Function()? btnOkOnPress}) {
    AwesomeDialog(
        context: context,
        titleTextStyle: TextStyle(
            fontSize: 17, color: Colors.red, fontWeight: FontWeight.bold),
        dialogType: dialogType,
        headerAnimationLoop: false,
        title: title,
        desc: desc,
        btnCancelText: btnCancelText,
        btnOkText: btnOkText,
        btnCancelOnPress: btnCancelShow ?? false ? () {} : btnCancelOnPress,
        btnOkOnPress: btnOkOnPress)
      ..show();
  }
}
