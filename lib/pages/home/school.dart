import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsaproject/components/school_navbar.dart';
import 'package:rsaproject/models.dart';
import 'package:rsaproject/pages/home/channel.dart';
import 'package:rsaproject/pages/home/schools.dart';
import 'package:rsaproject/pages/login.dart';
import 'package:rsaproject/router.dart';
import 'package:rsaproject/utils/api.dart';
import 'package:rsaproject/utils/colors.dart';

class School extends StatefulWidget {
  const School({super.key, required this.info});

  final SchoolInfo info;

  @override
  State<StatefulWidget> createState() => _School();
}

class _School extends State<School> {
  Widget currentPage = Container();
  String currentPath = "/";
  Map<String, Widget> paths = {};

  void changePage(String path) {
    if (paths.containsKey(path)) {
      setState(() {
        currentPage = paths[path]!;
        currentPath = path;
      });
    }
  }

  void loadChannels(AppStateModel state) async {
    var result = await getChannelsInSchool(state.user!, widget.info);
    if (result.code == 200) {
      for (var channel in result.data as List<dynamic>) {
        state.addChannel(widget.info.id, ChannelInfo.from(channel));
        print(channel);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    paths = {'/': Home(info: widget.info), '/school': SchoolPage()};

    changePage(currentPath);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final state = Provider.of<AppStateModel>(context, listen: false);
      state.clearChannels(widget.info.id);
      loadChannels(state);
      if (state.user == null) {
        Navigator.pushReplacement(
            context, createRoute((context) => const Login()));
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Flex(direction: Axis.vertical, children: [
          Material(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0)),
              color: darken(
                  Theme.of(context).colorScheme.surface,
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? 30
                      : 15),
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        IconButton(
                            splashRadius: 24.0,
                            onPressed: () {
                              Navigator.push(context,
                                  createRoute((context) => const Schools()));
                            },
                            icon: const Icon(Icons.menu_rounded, size: 32)),
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                widget.info.shortName ?? widget.info.name,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                      ],
                    ),
                  ))),
          Expanded(
              child: SafeArea(
            bottom: false,
            top: false,
            child: currentPage,
          )),
          SchoolNavbar(
            navigate: changePage,
            currentPage: currentPath,
          )
        ]));
  }
}

class Home extends StatelessWidget {
  const Home({super.key, required this.info});

  final SchoolInfo info;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(builder: (context, state, child) {
      return CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return ChannelCard(
              school: info,
              info: state.channels[info.id]![index],
            );
          }, childCount: state.channels[info.id]?.length ?? 0))
        ],
      );
    });
  }
}

class SchoolPage extends StatelessWidget {
  const SchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Under construction",
          style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

class ChannelCard extends StatelessWidget {
  const ChannelCard({super.key, required this.school, required this.info});

  final SchoolInfo school;
  final ChannelInfo info;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.surface,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Channel(school: school, channel: info)));
            },
            child: Container(
                child: Row(children: [
              const Icon(Icons.tag),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(info.name,
                      style: Theme.of(context).textTheme.headlineSmall))
            ]))));
  }
}
