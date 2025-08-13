import 'dart:convert';
import 'package:ets/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicListView extends StatefulWidget {
  final dynamic configdata;
  const DynamicListView({super.key,this.configdata});

  @override
  State<DynamicListView> createState() => _DynamicListViewState();
}

class _DynamicListViewState extends State<DynamicListView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<dynamic> statuses = [];
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
      statuses = data['statuses'];
      tasks = data['tasks'];
      _tabController = TabController(length: statuses.length, vsync: this);
    });
  }

  List<dynamic> getTasksByStatus(String statusKey) {
    return tasks.where((task) => task['status'] == statusKey).toList();
  }

  Widget buildTaskList(String statusKey) {
    var filteredTasks = getTasksByStatus(statusKey);

    if (filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        var task = filteredTasks[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(task['title'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(task['description']),
            trailing: Text(
              task['dueDate'],
              style: const TextStyle(color: Colors.grey),
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
            tabs: statuses.map((status) {
              // Count how many tasks have this status
              int count = tasks
                  .where((t) =>
                      t['status'].toString().toLowerCase() ==
                      status['label'].toString().toLowerCase())
                  .length;

              return Tab(
                text: "${status['label']} ($count)",
              );
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: statuses
                  .map((status) => buildTaskList(status['key']))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
