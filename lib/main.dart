import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rsaproject/loading.dart';
import 'package:rsaproject/models.dart';
import 'package:rsaproject/pages/app_home.dart';
import 'package:rsaproject/pages/login.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppStateModel()),
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Color.fromARGB(255, 13, 108, 197),
                onPrimary: Colors.white,
                secondary: Colors.blue,
                onSecondary: Colors.white,
                error: Color.fromARGB(255, 141, 41, 33),
                onError: Colors.white,
                background: Color.fromARGB(255, 255, 255, 255),
                onBackground: Color.fromARGB(255, 0, 0, 0),
                surface: Color.fromARGB(255, 226, 226, 226),
                onSurface: Color.fromARGB(255, 36, 36, 36))),
        darkTheme: ThemeData(
            colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: Color.fromARGB(255, 13, 108, 197),
                onPrimary: Colors.white,
                secondary: Colors.blue,
                onSecondary: Colors.white,
                error: Color.fromARGB(255, 206, 30, 17),
                onError: Colors.white,
                background: Colors.black,
                onBackground: Colors.white,
                surface: Color.fromARGB(255, 48, 48, 48),
                onSurface: Colors.white)),
        home: const Login());
  }
}
