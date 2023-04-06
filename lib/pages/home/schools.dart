import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rsaproject/models.dart';
import 'package:rsaproject/pages/home/add_school.dart';
import 'package:rsaproject/pages/home/create_school.dart';
import 'package:rsaproject/pages/home/school.dart';
import 'package:rsaproject/pages/login.dart';
import 'package:rsaproject/router.dart';
import 'package:rsaproject/utils/api.dart';

class Schools extends StatefulWidget {
  const Schools({super.key});

  @override
  State<StatefulWidget> createState() => _Schools();
}

class _Schools extends State<Schools> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final state = Provider.of<AppStateModel>(context, listen: false);
      if (state.user == null) {
        Navigator.pushReplacement(
            context, createRoute((context) => const Login()));
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
            child: Container(
                color: Theme.of(context).colorScheme.background,
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomScrollView(
                  slivers: [
                    Consumer<AppStateModel>(
                      builder: (context, state, child) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            return SchoolCard(info: state.schools[i]);
                          }, childCount: state.schools.length),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                            margin: const EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                            ),
                            child: MaterialButton(
                                color: Theme.of(context).colorScheme.primary,
                                child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.circlePlus,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                        Container(
                                            margin: const EdgeInsets.all(8.0),
                                            child: Text('Add a school',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondary)))
                                      ],
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddSchool()));
                                }))),
                    SliverToBoxAdapter(
                        child: Container(
                            margin: const EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                            ),
                            child: MaterialButton(
                                color: Theme.of(context).colorScheme.surface,
                                child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.circlePlus,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        Container(
                                            margin: const EdgeInsets.all(8.0),
                                            child: Text('Create a school',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface)))
                                      ],
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateSchool()));
                                })))
                  ],
                ))));
  }
}

class SchoolCard extends StatelessWidget {
  const SchoolCard({super.key, required this.info});
  final SchoolInfo info;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        color: Theme.of(context).colorScheme.surface,
        child: MaterialButton(
            child: Container(
                height: 70.0,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (info.logoUrl != null)
                          Image.network(info.logoUrl!, fit: BoxFit.cover)
                        else
                          const Icon(Icons.home_rounded, size: 52),
                        Flexible(
                            child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: ListTile(
                                    title: Text(info.shortName ?? info.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 18)),
                                    subtitle: Text(
                                        info.shortName != null ? info.name : "",
                                        overflow: TextOverflow.ellipsis)))),
                      ],
                    )),
                    const FaIcon(FontAwesomeIcons.angleRight)
                  ],
                )),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => School(info: info)));
            }));
  }
}
