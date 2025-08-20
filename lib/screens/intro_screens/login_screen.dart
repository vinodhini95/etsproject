// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ets/dynamic_widget/app_auth_button.dart';
import 'package:ets/dynamic_widget/apptext_formfield.dart';
import 'package:ets/dynamic_widget/center_image.dart';
import 'package:ets/provider/auth_provider.dart';
import 'package:ets/screens/home/applay_out.dart';
import 'package:ets/utils/assets.dart';
import 'package:ets/utils/dara_validator.dart';
import 'package:ets/utils/date_format.dart' show Validator;
import 'package:ets/utils/helper.dart';
import 'package:ets/utils/localization.dart';
import 'package:ets/utils/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final helper = Helper();
  bool isLogin = false;
  final GlobalKey<FormState> registerForm = GlobalKey<FormState>();
  final RoundedLoadingButtonController loginController =
      RoundedLoadingButtonController();

  TextEditingController emailIdController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  String _saveName = "";
  String get saveName => _saveName;
  bool _isPasswordVisible = false;
  Map<String, dynamic> totalData = {};
  Future<void> loadJsonData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/Cooking.json');
      json.decode(jsonString);
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  void loginButtonPressed(BuildContext context) async {
    if (!registerForm.currentState!.validate()) {
      loginController.reset();
      return;
    }
    try {
       Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CardHome()),
        );
      // var response = await context.read<AuthProvider>().Postauthlogin(
      //     emailIdController.text, PasswordController.text, false, context);
      // if (response['network'] == true) {
      //   await Helper().openAwesomeDialgue(context, DialogType.info,
      //       "Please check your internet connection", () {});

      //   loginController.reset();
      //   return;
      // }

      // if (response['status'] == 400) {
      //   await Helper().openAwesomeDialgue(
      //       context, DialogType.warning, response["data"]["message"], () {});
      //   loginController.reset();
      //   return;
      // }
      // if (response != null && response['status'] == 200) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => CardHome()),
      //   );
      // }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
              child: Column(
                children: [
                  Form(
                    key: registerForm,
                    child: Column(
                      children: [
                        CenterImage(
                          isNetworkImage: false,
                          imagePath: Assets.APP_LOGO,
                        ),
                        DateValidator().getSizedBoxHight(context, 30),
                        Helper().getTextField(
                            context, "LOGIN_TITLE", LoginTitleTextStyle),
                        DateValidator().getSizedBoxHight(context, 25),
                        AppTextFormField(
                          controller: emailIdController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          hintText: AppLocalizations.of(context)!
                                  .translate('EMAIL_ID') ??
                              '',
                          labelText: AppLocalizations.of(context)!
                                  .translate('EMAIL_ID') ??
                              '',
                          isRequired: true,
                          validator: (value) =>
                              Validator.emailvalidate(context, value),
                        ),
                        DateValidator().getSizedBoxHight(context, 30),
                        AppTextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: PasswordController,
                          hintText: AppLocalizations.of(context)!
                                  .translate('PASSWORD') ??
                              '',
                          labelText: AppLocalizations.of(context)!
                                  .translate('PASSWORD') ??
                              '',
                          isRequired: true,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                      .translate('ENTER_PASSWORD') ??
                                  '';
                            }
                            return null;
                          },
                          suffixIcon: _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          suffixIconOnTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        DateValidator().getSizedBoxHight(context, 20),
                        AppAuthButton(
                          borderRadius: 5,
                          width: 160,
                          icons: Icons.login,
                          controller: loginController,
                          onPressed: () => loginButtonPressed(context),
                          btnName: AppLocalizations.of(context)!
                                  .translate('BTN_LOGIN') ??
                              '',
                          iconIsRequired: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: launchURL,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(TextName.PoweredBy),
        //       Text(
        //         TextName.URL,
        //         style: UrlTextStyle,
        //       ),
        //       Text(
        //         TextName.Version,
        //         style: TextStyle(
        //           color: Colors.black,
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: 20,
        // )
      ],
    ));
  }

  @override
  void dispose() {
    PasswordController.dispose();
    emailIdController.dispose();
    super.dispose();
  }
}
