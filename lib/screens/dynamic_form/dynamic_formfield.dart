import 'dart:convert';
import 'package:ets/provider/json_data_provider.dart';
import 'package:ets/screens/dynamic_form/dynamic_list.dart';
import 'package:ets/service/api_service.dart';
import 'package:ets/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

typedef DynamicValidator = String? Function(String?);

class DynamicFormFieldBuilder extends StatefulWidget {
  final List<dynamic> fieldData;
  final GlobalKey<FormBuilderState> formKey;

  const DynamicFormFieldBuilder(
      {super.key, required this.fieldData, required this.formKey});

  @override
  State<DynamicFormFieldBuilder> createState() =>
      _DynamicFormFieldBuilderState();
}

class _DynamicFormFieldBuilderState extends State<DynamicFormFieldBuilder> {
  Map<String, Widget> routeMap = {};
  late bool obscureText;
  final List<bool> _isSelected = [true, false];
  var mediaQuery = 0.9;

  Map<String, bool> passwordVisibilityStates = {};
  Map<String, TextEditingController> controllers = {};

  late Future<dynamic> apiData;
  Map<String, dynamic>? value;

  @override
  void initState() {
    super.initState();
    obscureText = false;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initializeControllers();
    });
  }

  void initializeControllers() {
    for (var field in widget.fieldData) {
      if (field['type'] == 'TextField') {
        controllers[field['name']] = TextEditingController();
        controllers[field['name']]!.text = field['controllerValue'] ?? '';
        if (field['fieldType'] == 'password') {
          passwordVisibilityStates[field['name']] = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Ensures it fills available space in Column
      child: FormBuilder(
        key: widget.formKey,
        clearValueOnUnregister: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.fieldData.map<Widget>((field) {
              return buildFormField(context, field, widget.formKey);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildFormField(BuildContext context, Map<String, dynamic> fieldData,
      GlobalKey<FormBuilderState> formKey) {
    DynamicValidator getValidator(dynamic rule, String fieldName) {
      if (rule is Map<String, dynamic>) {
        if (rule.containsKey('pattern')) {
          String pattern = rule['pattern'];
          return (value) {
            if (rule.containsKey('required') &&
                rule['required'] == false &&
                (value == null || value.isEmpty)) {
              return null;
            } else if (value == null || value.isEmpty) {
              return 'Field is required';
            } else if (!RegExp(pattern).hasMatch(value)) {
              return 'Invalid format';
            }
            return null;
          };
        } else if (rule.containsKey('required') && rule['required'] == true) {
          return FormBuilderValidators.required(errorText: 'Field is required');
        } else {
          return (value) => null;
        }
      } else {
        return (value) => null;
      }
    }

    List<DynamicValidator> validators = [];

    if (fieldData.containsKey('validators') &&
        fieldData['validators'] is List) {
      for (var rule in fieldData['validators']) {
        validators.add(getValidator(rule, fieldData["name"]));
      }
    }

    switch (fieldData['type']) {
      case 'TextField':
        return FormBuilderTextField(
          name: fieldData['name'],
          obscureText: fieldData['fieldType'] == 'password'
              ? (passwordVisibilityStates[fieldData['name']] ?? true)
              : false,
          controller: controllers[fieldData['name']],
          keyboardType: TextInputType.number,
          validator: (value) {
            final composedValidator = (validators.isNotEmpty)
                ? FormBuilderValidators.compose(validators)
                : null;

            if (fieldData["name"] == "password" ||
                fieldData["name"] == "confirmPassword") {
              final passwordValue =
                  formKey.currentState?.fields["password"]?.value;

              if (fieldData["name"] == "confirmPassword" &&
                  passwordValue != null &&
                  passwordValue.isNotEmpty) {
                if (passwordValue != value) {
                  return 'Passwords do not match';
                }
              }
            }

            return composedValidator?.call(value);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: fieldData['label'],
            prefixIcon: fieldData['icon'] != null
                ? Icon(Helper().getIcon(fieldData['icon']))
                : null,
            suffixIcon: fieldData['suffixIcon'] != null
                ? getSuffixIcon(fieldData['name'], fieldData['fieldType'],
                    fieldData['suffixIcon'])
                : null,
          ),
        );

      case 'image_picker':
        return FormBuilderImagePicker(
            decoration: const InputDecoration(
              labelText: 'Upload Photos',
              labelStyle: TextStyle(fontSize: 22),
            ),
            name: fieldData['type'],
            previewMargin: const EdgeInsetsDirectional.only(end: 10),
            backgroundColor: Colors.transparent,
            icon: Icons.upload);
      case 'file_picker':
        return FormBuilderFilePicker(
          name: fieldData['type'],
          allowMultiple: true,
          typeSelectors: const [
            TypeSelector(
              type: FileType.any,
              selector: Row(
                children: <Widget>[
                  Icon(Icons.file_upload),
                  Text('Upload Files'),
                ],
              ),
            ),
          ],
        );
      case 'card':
        Map<String, dynamic> onTapData = fieldData["onTap"] ?? {};
        String navigatePath = onTapData["assetPath"] ?? "";
        String screenName = onTapData["screenName"] ?? "";
        String types = onTapData["euipment_type"] ?? "";

        return InkWell(
          child: Card(
            color: Helper().hashToHex(fieldData["card_color"] ?? "#D4E4D6"),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    fieldData['image'],
                    height: 30,
                    color: Helper()
                        .hashToHex(fieldData["text_color"] ?? "#195f49"),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  fieldData['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Helper()
                          .hashToHex(fieldData["text_color"] ?? "#195f49"),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          onTap: () async {
            String screenPath = fieldData["onTap"]?["screen_path"] ?? "";
            var screenConfig =
                await JsonDataProvider().loadJson(screenPath, context);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DynamicListView(
                        configdata: screenConfig,
                      )),
            );
          },
        );
      case 'GridView':
        List<dynamic> children = fieldData["children"];
        return GridView.count(
          shrinkWrap: true,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          crossAxisCount: 3,
          
          children: List.generate(children.length, (index) {
            return buildFormField(context, children[index], formKey);
          }),
        );

      case 'Dropdown':
        Future<dynamic> fetchDropdownDataFuture;

        if (fieldData["valueFrom"] == "Api") {
          fetchDropdownDataFuture = ApiService()
              .fetchDropdownData(fieldData['endPoint'], fieldData["filter"]);
        } else {
          // Directly use the items provided in fieldData["items"]
          fetchDropdownDataFuture = Future.value(fieldData["items"]);
        }

        return FutureBuilder<dynamic>(
          future: fetchDropdownDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic> dropdownData = snapshot.data!;
              return FormBuilderDropdown(
                name: fieldData['name'],
                decoration: InputDecoration(labelText: fieldData['label']),
                items: dropdownData.map((item) {
                  // Here you can modify each item in dropdownData if needed
                  // For example, adding a new key 'total_dropdown_data' with all dropdownData
                  item["total_dropdown_data"] = dropdownData;
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item[fieldData['labelName']].toString()),
                  );
                }).toList(),
              );
            }
          },
        );

      case 'SizeBox':
        return SizedBox(
          height: fieldData['height'],
          width: fieldData['width'],
        );
      case 'Text':
        var data;
        if (fieldData['dataType'] == 'date') {
          data = Helper().getFormattedTime(DateTime.now());
        } else {
          data = fieldData['data'];
        }
        return Text(
          data,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: fieldData['fontSize'] ?? 14.0),
        );
      case 'Row':
        List<dynamic> children = fieldData["children"];
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children
              .map((child) => buildFormField(context, child, formKey))
              .toList(),
        );
      case 'Column':
        List<dynamic> children = fieldData["children"];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children
              .map((child) => buildFormField(context, child, formKey))
              .toList(),
        );
      case 'Image':
        return Image.asset(
          fieldData['image'],
          height: 30,
          fit: BoxFit.cover,
        );
      case 'CircleAvatar':
        return CircleAvatar(
          radius: fieldData['radius'],
          backgroundImage: AssetImage(fieldData["backgroundImage"]),
        );
      case 'ElevatedButton':
        Map<String, dynamic> onTapData = fieldData["onTap"] ?? {};
        onTapData["euipment_type"] ?? "";
        // String navigatePath = onTapData["assetPath"] ?? "";
        return ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        );
      case 'Icon':
        return Icon(
          Icons.circle,
          color: Helper().hashToHex(fieldData["color"]),
        );
      case 'DatePicker':
        return FormBuilderDateTimePicker(
          name: "DatePicker",
          initialValue: DateTime.now(),
        );

      case 'ToggleButtons':
        return ToggleButtons(
          isSelected: _isSelected,
          onPressed: (int index) {
            setState(() {
              _isSelected[0] = false;
              _isSelected[1] = false;
              _isSelected[index] = true;
            });
          },
          color: Colors.black,
          selectedColor: Colors.white,
          fillColor: Colors.blue,
          borderColor: Colors.grey,
          selectedBorderColor: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Machine Shelling'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Manual Shelling'),
            ),
          ],
        );
      case 'ListView':
        List<dynamic> children = fieldData["children"];
        return SizedBox(
          width: MediaQuery.of(context).size.width / 0.5,
          height: MediaQuery.of(context).size.height / 7,
          child: ListView.builder(
            itemCount: children.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    // color:children[index]["type"] !="SizeBox" ? Colors.grey[200]:Colors.transparent, // Set the background color to light gray
                    child: buildFormField(context, children[index], formKey),
                  ),
                ),
              );
            },
          ),
        );

      case 'MaterialButton':
        fieldData["onTap"] ?? {};

        return MaterialButton(
          color: const Color.fromARGB(255, 241, 95, 4),
          onPressed: () {
            if (formKey.currentState?.saveAndValidate() ?? false) {}
          },
          child: Text(
            fieldData['submit'],
            style: const TextStyle(color: Colors.white),
          ),
        );

      default:
        return const SizedBox();
    }
  }

  Widget getSuffixIcon(String fieldName, String fieldType, String suffixIcon) {
    if (fieldType == 'password' && suffixIcon == 'visibility') {
      return InkWell(
        onTap: () {
          setState(() {
            togglePasswordVisibility(fieldName);

            obscureText = passwordVisibilityStates[fieldName]!;
          });
        },
        child: Icon(
          (passwordVisibilityStates[fieldName] ?? true)
              ? Icons.visibility_off
              : Icons.visibility,
        ),
      );
    } else if (fieldType == 'barcode' && suffixIcon == 'barcode') {
      return InkWell(
        onTap: () async {},
        child: const Icon(Icons.qr_code_scanner),
      );
    } else {
      return Icon(Helper().getIcon(suffixIcon));
    }
  }

  void togglePasswordVisibility(String fieldName) {
    if (passwordVisibilityStates.containsKey(fieldName)) {
      passwordVisibilityStates[fieldName] =
          !passwordVisibilityStates[fieldName]!;
    } else {
      passwordVisibilityStates[fieldName] = true;
    }
  }

  Widget getScreenWidget(
      String screenName, String types, Map<String, dynamic>? totalData) {
    return routeMap[screenName]!;
  }
}
