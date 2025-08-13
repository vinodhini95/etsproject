
import 'package:ets/utils/color.dart';
import 'package:ets/utils/helper.dart';
import 'package:ets/utils/text_style.dart';
import 'package:flutter/material.dart';

class AppEllevatedAuthButton extends StatelessWidget {
  const AppEllevatedAuthButton({
    Key? key,
    required this.onPressed,
    required this.btnName,
    this.primaryColor,
    this.textColor,
    this.side,
    required this.iconIsrequired,
    this.icons,
    this.imagePath,
  }) : super(key: key);
  final void Function()? onPressed;
  final Color? primaryColor;
  final Color? textColor;
  final String btnName;
  final BorderSide? side;
  final bool iconIsrequired;
  final IconData? icons;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        // width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
              elevation: 4,
              side: side,
              backgroundColor: primaryColor ?? buttonColor,
              // backgroundColor: buttonColor,
              minimumSize: const Size(double.infinity, 45)),

          // ignore: sort_child_properties_last
          child: iconIsrequired == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePath != null
                        ? Image.asset(
                            imagePath!,
                            height: 23,
                            color: whiteButtonColor,
                          )
                        : Icon(icons, size: 18),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                        child: Helper().getTextFieldWioutTransulator(
                            context, btnName, AuthBtnTextStyle)),
                  ],
                )
              : Helper().getTextFieldWioutTransulator(
                  context,
                  btnName,
                  TextStyle(
                    color: textColor != null ? textColor! : whiteButtonColor,
                    fontSize: 14,
                  )),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
