import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rsaproject/utils/api.dart';

class AppStateModel extends ChangeNotifier {
  User? _user;
  final List<SchoolInfo> _schools = [];
  final Map<int, List<ChannelInfo>> _channels = {};

  User? get user => _user;
  UnmodifiableListView<SchoolInfo> get schools =>
      UnmodifiableListView(_schools);
  UnmodifiableMapView<int, List<ChannelInfo>> get channels =>
      UnmodifiableMapView(_channels);

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearSchools() {
    _schools.clear();
    notifyListeners();
  }

  void addSchool(SchoolInfo school) {
    _schools.add(school);
    notifyListeners();
  }

  void addChannel(int id, ChannelInfo channel) {
    if (_channels[id] == null) {
      _channels[id] = [];
    }
    _channels[id]!.add(channel);
    notifyListeners();
  }

  void clearChannels(int id) {
    if (_channels[id] == null) {
      _channels[id] = [];
    }

    _channels[id] = [];
    notifyListeners();
  }
}
