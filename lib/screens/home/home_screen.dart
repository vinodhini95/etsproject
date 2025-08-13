
import 'dart:convert';

import 'package:ets/screens/dynamic_form/dynamic_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic>? detailData;
  Map<String, dynamic> totalData = {};
  String title = "";
  final formKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      loadJsonData();
    });
  }

  Future<void> loadJsonData() async {
    try {
      String jsonData = await rootBundle.loadString('assets/json/home_screen.json');
      Map<String, dynamic> decodedData = json.decode(jsonData);
      setState(() {
        detailData = decodedData["children"];
        title = decodedData["title"];
        totalData = decodedData;
      });
    } catch (e) {
      print("Error loading json: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: detailData == null
          ? const Center(child: CircularProgressIndicator())
          : detailData!.isEmpty
              ? const Center(child: Text("No form data available"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      DynamicFormFieldBuilder(
                        fieldData: detailData!,
                        formKey: formKey,
                      ),
                    ],
                  ),
                ),
    );
  }
}
