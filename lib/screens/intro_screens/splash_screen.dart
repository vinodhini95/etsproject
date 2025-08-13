import 'dart:async';
import 'package:ets/screens/intro_screens/instalation.dart';
import 'package:ets/screens/intro_screens/login_screen.dart';
import 'package:ets/utils/assets.dart';
import 'package:ets/utils/localization.dart';
import 'package:ets/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:ets/app_style/app_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<SplashScreen> {
  var _visible = true;
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  bool get wantKeepAlive => true;

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeOut,
    );

    animation!.addListener(() => setState(() {}));
    animationController!.forward();

    setState(() {
      _visible = !_visible;
    });

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Image.asset(
                  'assets/images/kriyatec.png',
                  width: animation!.value * 180,
                  height: animation!.value * 180,
                  fit: BoxFit.scaleDown,
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Assets.APP_LOGO,
                scale: 0.3,
                width: animation!.value * 210,
                height: animation!.value * 210,
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate(StringData.APP_NAME) ?? '',
                style: AppStyles().appTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
