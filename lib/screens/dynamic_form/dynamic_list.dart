import 'dart:convert';
import 'package:ets/dynamic_widget/app_elevator_button.dart';
import 'package:ets/screens/dynamic_form/dynamic_view_screen.dart';
import 'package:ets/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicListView extends StatefulWidget {
  final dynamic configdata;
  const DynamicListView({super.key, required this.configdata});

  @override
  State<DynamicListView> createState() => _DynamicListViewState();
}

class _DynamicListViewState extends State<DynamicListView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String jsonString =
        await rootBundle.loadString(widget.configdata["screen_path"]);
    final data = json.decode(jsonString);

    setState(() {
      tasks = data;
      if (widget.configdata["showtab"] == true) {
        _tabController = TabController(
          length: widget.configdata["tab_list"]?.length ?? 0,
          vsync: this,
        );
      }
    });
  }

  String formatValue(dynamic value, Map<String, dynamic> field) {
    if (value == null) return "";
    if (value is Map && value.containsKey("\$date")) {
      value = value["\$date"];
    }
    switch (field["type"]) {
      case "dateTime":
        DateTime? date;
        if (value is String) {
          date = DateTime.tryParse(value);
        }
        if (date != null) {
          if (field["formate"] == "local") {
            date = date.toLocal();
          }
          return DateFormat("dd-MMM-yyyy").format(date);
        }
        break;
      default:
        return value.toString();
    }
    return "";
  }

  Color parseColor(String? colorName) {
    switch (colorName) {
      case "PrimaryColor":
        return Theme.of(context).primaryColor;
      case "blackColor":
        return Colors.black;
      case "whiteColor":
        return Colors.white;
      default:
        return Colors.black;
    }
  }

 Widget buildCard(Map<String, dynamic> task) {
  var fields = widget.configdata["fields"];
  var leftFields = fields.take(2).toList();
  var rightFields = fields.skip(2).toList();
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey, width: 1), // underline
      ),
    ),
    padding: const EdgeInsets.all(12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // LEFT SIDE
        Row(
          children: [
            widget.configdata["is_employee"] == true
                ? CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(Icons.person, color: Colors.grey.shade700),
                  )
                : const SizedBox.shrink(),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: leftFields.map<Widget>((field) {
                dynamic rawValue = task[field["value"]];
                String displayValue = formatValue(rawValue, field);
                return Text(
                  displayValue,
                  style: TextStyle(
                    fontSize:
                        (field["style"]?["fontSize"] ?? 14).toDouble(),
                    fontWeight: field["style"]?["fontWeight"] == "bold"
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: parseColor(field["style"]?["color"]),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // RIGHT SIDE
        Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: rightFields.map<Widget>((field) {
    dynamic rawValue = task[field["value"]];
    String displayValue = formatValue(rawValue, field);

    Widget textWidget = Text(
      displayValue,
      style: TextStyle(
        fontSize: (field["style"]?["fontSize"] ?? 14).toDouble(),
        fontWeight: field["style"]?["fontWeight"] == "bold"
            ? FontWeight.bold
            : FontWeight.normal,
        color: parseColor(field["style"]?["color"]),
      ),
    );

    if (field["type"] == "number") {
      return GestureDetector(
        onTap: () async {
          final Uri uri = Uri(scheme: "tel", path: displayValue);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw 'Could not launch $displayValue';
          }
        },
        child: textWidget,
      );
    }

    return textWidget;
  }).toList(),
)

      ],
    ),
  );
}
  List<Map<String, dynamic>> filterTasks(String key) {
    DateTime now = DateTime.now();
    var dateField = widget.configdata["fields"]
        .firstWhere((f) => f["type"] == "dateTime", orElse: () => null);

    if(widget.configdata["is_employee"] == true) {
      return tasks
        .where((task) {
          switch (key) {
            case "absent":
            return task["is_sign"] == false; // Absent if not signed
            case "present":
            return task["is_sign"] == true;     
            default:
              return true;
          }
        })
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    }  

    if (dateField == null) return [];

    return tasks
        .where((task) {
          var rawValue = task[dateField["value"]];
          DateTime? taskDate;
          if (rawValue is String) {
            taskDate = DateTime.tryParse(rawValue);
          } else if (rawValue is Map && rawValue.containsKey("\$date")) {
            taskDate = DateTime.tryParse(rawValue["\$date"]);
          }
          if (taskDate == null) return false;

          switch (key) {
            case "ongoing":
              return taskDate.isBefore(now) &&
                  taskDate.isAfter(now.subtract(Duration(days: 1)));
            case "upcoming":
              return taskDate.isAfter(now);
            case "completed":
              return taskDate.isBefore(now);
            case "due":
              return taskDate.isBefore(now) &&
                  taskDate.isAfter(now.subtract(Duration(days: 7))); 
            default:
              return true;
          }
        })
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Widget buildList(List<dynamic> listData) {
    if (listData.isEmpty) {
      return const Center(child: Text("No data found"));
    }
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index) {
        return buildCard(listData[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar:
          AppBar(title: Text(widget.configdata["appbar"] ?? "Dynamic List")),
      body: widget.configdata["showtab"] == true
          ? Column(
              children: [
                if(widget.configdata["is_employee"] == true)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AppEllevatedAuthButton(onPressed: () { 
                     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  CameraDropdownScreen()),
    );
                   }, btnName: 'Sign-In',icons: Icons.login_rounded,iconIsrequired: true,primaryColor: Theme.of(context).primaryColor,textColor: whiteButtonColor,),
                ),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black,
                  tabs: widget.configdata["tab_list"].map<Widget>((tab) {
                    String key = tab["key"];
                    int count = filterTasks(key).length;
                    return Tab(text: "${tab["lable"]} ($count)");
                  }).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: widget.configdata["tab_list"].map<Widget>((tab) {
                      String key = tab["key"];
                      return buildList(filterTasks(key));
                    }).toList(),
                  ),
                ),
              ],
            )
          : buildList(tasks),
    );
  }
}
