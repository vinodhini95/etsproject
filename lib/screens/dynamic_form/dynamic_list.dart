import 'dart:convert';
import 'package:ets/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
        await rootBundle.loadString('assets/json/sample_data/tasks.json');
    final data = json.decode(jsonString);

    setState(() {
      tasks = data; // directly using your JSON list
      _tabController =
          TabController(length: widget.configdata["tab_count"], vsync: this);
    });
  }

 String getScheduleStatus(Map<String, dynamic> task) {
  final today = DateTime.now();

  // Safely get schedule date
  String? dateStr = task["schedule_start_date"]?["\$date"];
  if (dateStr == null) return "No Date";

  final scheduleDate = DateTime.tryParse(dateStr);
  if (scheduleDate == null) return "No Date";

  if (task["task_status"]?.toString().toUpperCase() == "COMPLETED") {
    return "Completed";
  } else if (isSameDay(scheduleDate, today)) {
    return "Ongoing";
  } else if (scheduleDate.isAfter(today)) {
    return "Upcoming";
  } else {
    return "Due";
  }
}


  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  List<dynamic> getTasksBySchedule(String scheduleKey) {
    return tasks.where((task) {
      return getScheduleStatus(task).toLowerCase() ==
          scheduleKey.toLowerCase();
    }).toList();
  }

  Widget buildTaskList(String scheduleKey) {
    var filteredTasks = getTasksBySchedule(scheduleKey);

    if (filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        var task = filteredTasks[index];
        String scheduleStatus = getScheduleStatus(task);
        String projectName = task["project_id"] ?? "";
        String buildingName = task["building_name"] ?? "";
        DateTime scheduleDate =
            DateTime.parse(task["schedule_start_date"]["\$date"].toString());

        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project and building
                Text(
                  "$projectName${buildingName.isNotEmpty ? " - $buildingName" : ""}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                // Task Name
                Text(
                  task['name'] ?? "",
                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 8),

                // Bottom row with date and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat("dd-MMM-yyyy").format(scheduleDate),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          scheduleStatus,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: scheduleStatus == "Upcoming"
                                ? Colors.blue
                                : scheduleStatus == "Ongoing"
                                    ? Colors.green
                                    : scheduleStatus == "Completed"
                                        ? Colors.grey
                                        : Colors.red,
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: whiteButtonColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Task List"),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            dividerColor: greyColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: widget.configdata["tab_list"].map<Widget>((status) {
              int count = getTasksBySchedule(status['lable']).length;
              return Tab(text: "${status['lable']} ($count)");
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.configdata["tab_list"]
                  .map<Widget>((status) => buildTaskList(status['lable']))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
