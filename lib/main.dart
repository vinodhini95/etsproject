import 'package:ets/local_db.dart';
import 'package:ets/screens/intro_screens/splash_screen.dart';
import 'package:ets/utils/initialition_package.dart';
import 'package:ets/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
late LocalDB localDB;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: InitiateFlutterPackage().getProviderChangeNotifier(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        // 🌍 Localization setup
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('hi'), // Hindi
          Locale('ta'), // Tamil
        ],
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: Color.fromARGB(255, 178, 17, 6),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,

          primary: const Color.fromARGB(255, 178, 17, 6)),
        ),
        home: const SplashScreen(), 
      ),
    );
  }
}