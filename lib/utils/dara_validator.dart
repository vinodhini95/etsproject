import 'package:flutter/material.dart';

class DateValidator {
  //dynamic sized box for hight
  getSizedBoxHight(BuildContext context, double value) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / value,
    );
  }

  //dynamic sized box for width
  getSizedBoxWidth(BuildContext context, double value) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / value,
    );
  }

  getCommantFontSize(BuildContext context, double value) {
    return MediaQuery.of(context).size.height / value;
  }

  getCommantFontSizewith(BuildContext context, double value) {
    return MediaQuery.of(context).size.width / value;
  }

  Widget getSizedBoxHeight(BuildContext context, double height) {
    return SizedBox(height: height);
  }
 

}
