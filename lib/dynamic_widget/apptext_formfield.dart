
import 'package:ets/utils/color.dart';
import 'package:ets/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextStyle? prefixStyle;
  final AutovalidateMode? autovalidateMode;
  final Widget? icons;
  final bool? readOnly;
  final Widget? counter;
  final String? counterText;
  final Widget? suffix;
  final EdgeInsetsGeometry? contentPadding;
  final String? preText;
  final void Function()? suffixIconOnTap;
  final bool? obscureText;
  final TextStyle? style;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormat;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final Color? borderColor;
  final int? maxLines;
  final int? maxlength;
  final double? height;
  final String? suffixText;
  final bool? isDense;
  final FocusNode? focus;
  final bool isRequired;
  final String? errorMessage;
  final String? initialValue;
  final TextStyle? labletextstyle;
    final TextStyle? hinttextstyle;

  const AppTextFormField({
    Key? key,
    obscuringCharacter = '•',
    this.focus,
    this.onTap,
    this.icons,
    required this.isRequired,
    this.keyboardType,
    this.autovalidateMode,
    this.readOnly,
    this.suffix,
    this.counterText,
    this.style,
    this.counter,
    this.suffixText,
    this.contentPadding,
    this.preText,
    this.validator,
    this.onSaved,
    this.hintText,
    this.prefixIcon,
    this.isDense,
    this.prefixStyle,
    this.suffixIcon,
    this.suffixIconOnTap,
    this.inputFormat,
    this.obscureText,
    this.onChanged,
    this.labelText,
    this.maxlength,
    this.controller,
    this.borderColor,
    this.height,
    this.maxLines,
    this.errorMessage,
    this.initialValue,
    this.labletextstyle,
    this.hinttextstyle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          style:AppTextFormFieldTextStyle,
          initialValue: initialValue ?? null,
          autovalidateMode: autovalidateMode,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
          focusNode: focus,
          inputFormatters: inputFormat,
          obscureText: obscureText ?? false,
          onChanged: onChanged,
          maxLines: maxLines ?? 1,
          maxLength: maxlength,
          cursorHeight: height,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            // contentPadding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 20.0),
            isDense: isDense,
            icon: icons,
            counter: counter,
            prefixStyle: prefixStyle,
            counterText: "",
            prefixText: preText,
            errorStyle: const TextStyle(color: Colors.red),
            filled: true,
            fillColor: Colors.white,
            label: Text.rich(TextSpan(
              text: labelText,
              style: labletextstyle ?? AppTextFormFieldTextStyle,
              children: [
                if (isRequired == true)
                  const TextSpan(text: "*", style: TextStyle(color: Colors.red))
              ],
            )),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor ?? const Color.fromARGB(255, 117, 116, 116))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor ?? Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor ?? Colors.grey)),
            suffixIcon: suffixIconOnTap != null
                ? IconButton(
                    onPressed: suffixIconOnTap,
                    icon: Icon(suffixIcon),
                    color: BlackColor,
                  )
                : null,
            hintText: hintText,
            hintStyle:hinttextstyle ?? AppTextFormFieldTextStyle,
          ),
        ),
      ],
    );
  }
}
