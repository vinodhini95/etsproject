
import 'package:ets/utils/color.dart';
import 'package:ets/utils/helper.dart';
import 'package:ets/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AppAuthButton extends StatelessWidget {
  const AppAuthButton({
    Key? key,
    required this.onPressed,
    required this.btnName,
    this.primaryColor,
    this.textColor,
    this.side,
    required this.iconIsRequired,
    this.icons,
    this.imagePath,
    required this.controller,
    this.borderRadius = 15.0,
    this.width = double.infinity,
  }) : super(key: key);

  final void Function()? onPressed;
  final Color? primaryColor;
  final Color? textColor;
  final String btnName;
  final BorderSide? side;
  final bool iconIsRequired;
  final IconData? icons;
  final String? imagePath;
  final RoundedLoadingButtonController controller;
  final double borderRadius;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: RoundedLoadingButton(
        controller: controller,
        onPressed: onPressed,
        color: Theme.of(context).colorScheme.primary,
        borderRadius: borderRadius,
        successColor: Theme.of(context).colorScheme.primary,
        child: iconIsRequired
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imagePath != null)
                    Image.asset(
                      imagePath!,
                      height: 23,
                      color: whiteButtonColor,
                    )
                  else if (icons != null)
                    Icon(icons, size: 20,color: whiteButtonColor,),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Helper().getTextFieldWioutTransulator(context, btnName,AuthBtnTextStyle.copyWith(
                        color: textColor ?? whiteButtonColor,
                      )),
                  ),
                ],
              )
            : Helper().getTextFieldWioutTransulator(context, btnName,TextStyle(
                  color: textColor ?? whiteButtonColor,
                  fontSize: 16,
                )) 
      ),
    );
  }
}
