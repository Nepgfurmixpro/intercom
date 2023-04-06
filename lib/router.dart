import 'package:flutter/material.dart';

Route createRoute(Function(BuildContext) builder) {
  return PageRouteBuilder(
    pageBuilder: ((context, animation, secondaryAnimation) => builder(context)),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.ease));
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
