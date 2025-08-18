// ignore_for_file: file_names, deprecated_member_use

import 'package:ets/app_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DropDownButtonwidgetMap extends StatelessWidget {
  const DropDownButtonwidgetMap({
    super.key,
    required this.isrequired,
    this.selectedValue,
    required this.listArrayValues,
    this.onChanged,
    required this.isImageRequired,
    this.hintText,
  });

  final String? selectedValue;
  final List<dynamic> listArrayValues;
  final void Function(dynamic)? onChanged;
  final String? hintText;
  final bool isrequired;
  final bool isImageRequired;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text.rich(
            TextSpan(
              text: hintText,
              style: DroupDownTextStyle,
              children: [
                if (isrequired == true)
                  TextSpan(text: "*", style: TextStyle(color: Theme.of(context).colorScheme.primary))
              ],
            ),
          ),
          items: listArrayValues.map((dynamic item) {
            return DropdownMenuItem<String>(
              value: item["_id"]?.toString(),
              child: Row(
                children: [
                  Text(
                    item["template_name"]?.toString() ?? item["name"] ?? "",
                    style: DroupDownTextStyle1,
                    overflow: TextOverflow.ellipsis,
                  )
                ]
              )
            );
          }).toList(),
          value: selectedValue,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary
              )
            )
          ),
          iconStyleData: IconStyleData(
            icon: const Icon(
              Icons.arrow_drop_down_outlined,
              size: 27,
            ),
            iconSize: 14,
            iconEnabledColor: Theme.of(context).colorScheme.primary,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14)
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true)
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          )
        )
      )
    );
  }
}
