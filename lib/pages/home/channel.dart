import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rsaproject/models.dart';
import 'package:rsaproject/pages/login.dart';
import 'package:rsaproject/router.dart';
import 'package:rsaproject/utils/api.dart';
import 'package:rsaproject/utils/colors.dart';
import 'package:avoid_keyboard/avoid_keyboard.dart';

class Channel extends StatefulWidget {
  Channel({super.key, required this.school, required this.channel});

  final SchoolInfo school;
  final ChannelInfo channel;

  @override
  State<StatefulWidget> createState() => _Channel();
}

class _Channel extends State<Channel> {
  TextEditingController messageInput = TextEditingController();
  ScrollController messageScrollController = ScrollController();

  final List<MessageInfo> _messages = [];
  UnmodifiableListView<MessageInfo> get messages =>
      UnmodifiableListView(_messages.reversed.toList());

  void sendMessage(AppStateModel state) async {
    var message = messageInput.text;
    messageInput.text = "";

    var response = await sendMessageToChannel(
        state.user!, widget.school, widget.channel, message);
    if (response.code != 200) {
      messageInput.text = message;
    }
  }

  void createMessage(MessageInfo info) {
    setState(() {
      _messages.add(info);
    });
  }

  void loadMessages(AppStateModel state) async {
    final res =
        await getMessagesInChannel(state.user!, widget.school, widget.channel);
    if (res.code == 200) {
      final messages = res.data as List<dynamic>;
      for (var message in messages) {
        createMessage(MessageInfo.from(message));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      messageScrollController
          .jumpTo(messageScrollController.position.maxScrollExtent);
    });
  }

  @override
  void initState() {
    super.initState();

    final state = Provider.of<AppStateModel>(context, listen: false);
    if (state.user == null) {
      Navigator.pushReplacement(
          context, createRoute((context) => const Login()));
      return;
    }

    loadMessages(state);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      messageScrollController
          .jumpTo(messageScrollController.position.maxScrollExtent);
    });
  }

  @override
  void didUpdateWidget(Channel old) {
    super.didUpdateWidget(old);
    messageScrollController
        .jumpTo(messageScrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [
              Material(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)),
                  color: darken(
                      Theme.of(context).colorScheme.surface,
                      MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
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
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.menu_rounded, size: 32)),
                            Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.channel.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall))
                          ],
                        ),
                      ))),
              Expanded(
                child: CustomScrollView(
                  controller: messageScrollController,
                  slivers: [
                    const SliverFillRemaining(
                      hasScrollBody: false,
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                            padding: const EdgeInsets.all(48.0),
                            child: Flex(
                              direction: Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("# ${widget.channel.name}",
                                    style: const TextStyle(fontSize: 24)),
                                Text(widget.channel.description,
                                    style: const TextStyle(fontSize: 16))
                              ],
                            ))),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      final message = messages[index];
                      return Container(
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? darken(
                                  Theme.of(context).colorScheme.surface, 20)
                              : darken(
                                  Theme.of(context).colorScheme.surface, 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: ((() {
                                  if (message.author.avatarHash == null) {
                                    return const Icon(Icons.person_rounded,
                                        size: 48);
                                  }
                                  return Image(
                                      image: NetworkImage(
                                          message.author.avatarHash!));
                                })()),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(message.author.getName(),
                                      style: TextStyle(fontSize: 22)),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        style: TextStyle(fontFamily: "Roboto"),
                                        message.content!,
                                        softWrap: true,
                                      ))
                                ],
                              )
                            ],
                          ));
                    }, childCount: messages.length))
                  ],
                ),
              ),
              Material(
                  color: darken(
                      Theme.of(context).colorScheme.surface,
                      MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? 30
                          : 8),
                  child: SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: TextField(
                                  controller: messageInput,
                                  decoration: const InputDecoration(
                                      hintText: 'Message',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24.0))),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 18.0))),
                            ),
                            IconButton(
                                splashRadius: 28.0,
                                onPressed: () {
                                  sendMessage(state);
                                },
                                iconSize: 32,
                                splashColor:
                                    Theme.of(context).colorScheme.primary,
                                icon: const Icon(Icons.send_rounded)),
                          ]),
                    ),
                  ))
            ],
          )),
    );
  }
}
