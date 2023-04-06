import 'dart:convert';

import 'package:flutter/material.dart';

class SchoolNavbar extends StatefulWidget {
  const SchoolNavbar(
      {super.key, required this.navigate, required this.currentPage});

  final Function(String) navigate;
  final String currentPage;

  @override
  State<StatefulWidget> createState() => _SchoolNavbar();
}

class _SchoolNavbar extends State<SchoolNavbar> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
            top: false,
            child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  children: [
                    RouteIcon(
                      icon: Icons.home,
                      path: '/',
                      navigate: widget.navigate,
                      currentRoute: widget.currentPage,
                    ),
                    RouteIcon(
                        icon: Icons.school_rounded,
                        path: '/school',
                        navigate: widget.navigate,
                        currentRoute: widget.currentPage),
                    RouteIcon(
                        icon: Icons.person_rounded,
                        path: '/user',
                        navigate: widget.navigate,
                        currentRoute: widget.currentPage),
                    RouteIcon(
                        icon: Icons.settings,
                        path: '/settings',
                        navigate: widget.navigate,
                        currentRoute: widget.currentPage),
                  ],
                ))));
  }
}

class RouteIcon extends StatelessWidget {
  RouteIcon(
      {super.key,
      required this.icon,
      required this.path,
      required this.navigate,
      required this.currentRoute});

  final IconData icon;
  final String path;
  final Function(String) navigate;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          navigate.call(path);
        },
        iconSize: 32,
        icon: Icon(icon,
            color: currentRoute == path
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground));
  }
}
