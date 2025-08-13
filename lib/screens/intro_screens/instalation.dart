import 'dart:async';
import 'package:ets/app_style/app_style.dart';
import 'package:ets/screens/intro_screens/login_screen.dart';
import 'package:ets/utils/assets.dart';
import 'package:ets/utils/localization.dart';
import 'package:ets/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class InstallationScreen extends StatefulWidget {
  @override
  _InstallationScreenState createState() => _InstallationScreenState();
}

class _InstallationScreenState extends State<InstallationScreen> {
  TextEditingController textEditingController = TextEditingController();
  final RoundedLoadingButtonController installBtnController =
      RoundedLoadingButtonController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  Color color = AppStyles().defalutAppColor;
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height - 55,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          Assets.APP_LOGO,
                          scale: 0.3,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                       AppLocalizations.of(context)!.translate(StringData.APP_NAME) ?? '',
                      style: AppStyles().appTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 35),
                    Container(
                      child: Column(
                        children: [
                          Center(
                              child: Text(AppLocalizations.of(context)!.translate(StringData.INSTALLATION_TITLE_TEXT) ?? '',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[600]))),
                          SizedBox(
                            height: 15.0,
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                child: PinCodeTextField(
                                  appContext: context,
                                  pastedTextStyle: TextStyle(
                                    color: Colors.green.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  length: 6,
                                  blinkWhenObscuring: true,
                                  animationType: AnimationType.fade,
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "* Please fill up all the cells properly";
                                    } else {
                                      return null;
                                    }
                                  },
                                  errorTextSpace: 30.0,
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 45,
                                      fieldWidth: 45,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      selectedFillColor: Colors.white,
                                      inactiveColor: Colors.grey),
                                  cursorColor: Colors.black,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  enableActiveFill: true,
                                  errorAnimationController: errorController,
                                  controller: textEditingController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  keyboardType: TextInputType.visiblePassword,
                                  boxShadows: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Colors.black12,
                                      blurRadius: 10,
                                    )
                                  ],
                                  onCompleted: (v) {},
                                  onChanged: (value) {
                                    setState(() {
                                      currentText = value.toUpperCase();
                                    });
                                  },
                                  beforeTextPaste: (text) {
                                    return true;
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                    RoundedLoadingButton(
                      borderRadius: 5,
                      valueColor: Theme.of(context).primaryColor,
                      color: color,
                      controller: installBtnController,
                      onPressed: () async => verifyInstallationCode(),
                      child: Text(
                        AppLocalizations.of(context)!.translate(StringData.LET_START_TEXT) ?? '',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //     child: Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     child: Image.asset(Assets.KRIYATEC_IMG),
              //     height: 30.0,
              //   ),
              // ))
            ],
          ),
        ),
      ),
    );
  }

  verifyInstallationCode() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  LoginScreen()),
    ); 
  }
}
