import 'package:flutter/material.dart';
import 'package:rsaproject/loading.dart';

import 'home/schools.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<StatefulWidget> createState() => _AppHome();
}

class _AppHome extends State<AppHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context),
        home: const Schools());
  }
}
