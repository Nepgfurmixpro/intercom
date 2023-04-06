import 'dart:convert';

import 'package:http/http.dart';
import 'package:rsaproject/models.dart';

const String BASE_URL = "https://intercom.neothedeveloper.com";

class User {
  User(
      {required this.id,
      required this.avatarHash,
      required this.firstName,
      required this.lastName,
      required this.middleInitial,
      required this.flags,
      required this.nickname,
      this.authToken,
      this.email});

  final int id;
  final String? authToken;
  final String? avatarHash;
  final String? email;
  final String firstName;
  final String lastName;
  final String? middleInitial;
  final int flags;
  final String? nickname;

  String getName() {
    var string = "";
    string += "${nickname ?? firstName} ";
    if (middleInitial != null) {
      string += '$middleInitial ';
    }
    string += lastName;
    return string;
  }

  static User from(Map<String, dynamic> data) {
    return User(
        id: data['id'],
        avatarHash: data['avatar_hash'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        middleInitial: data['middle_initial'],
        flags: data['flags'],
        nickname: data['nickname'],
        authToken: data['auth_token'],
        email: data['email']);
  }
}

class SchoolInfo {
  SchoolInfo(
      {required this.id,
      required this.name,
      required this.logoUrl,
      required this.shortName,
      required this.owner});
  final int id;
  final String name;
  final String? shortName;
  final String? logoUrl;
  final bool owner;

  static SchoolInfo from(Map<String, dynamic> data) {
    return SchoolInfo(
      id: data['id'],
      name: data['name'],
      shortName: data['short_name'],
      logoUrl: data['logo_url'],
      owner: data['owner'],
    );
  }
}

class ChannelInfo {
  ChannelInfo(
      {required this.id,
      required this.parentId,
      required this.specialityTag,
      required this.type,
      required this.name,
      required this.description});
  final int id;
  final int? parentId;
  final String? specialityTag;
  final int type;
  final String name;
  final String description;

  static ChannelInfo from(Map<String, dynamic> data) {
    return ChannelInfo(
        id: data['id'],
        name: data['name'],
        parentId: data['parent_id'],
        description: data['description'],
        type: data['type'],
        specialityTag: data['specialty_tag']);
  }
}

class MessageInfo {
  MessageInfo({required this.id, required this.author, required this.content});

  final int id;
  final User author;
  final String? content;

  static MessageInfo from(Map<String, dynamic> data) {
    return MessageInfo(
        id: data['id'],
        author: User.from(data['author']),
        content: data['content']);
  }
}

class Response {
  Response(this.code, this.data);

  final int code;
  final dynamic data;
}

Future<Response> loginUser(String email, String password) async {
  final url = Uri.parse('$BASE_URL/auth/users/login');
  final headers = {"Content-type": "application/json"};
  final data = {'email': email, 'password': password};
  final json = jsonEncode(data);
  final response = await post(url, headers: headers, body: json);
  return Response(response.statusCode, jsonDecode(response.body));
}

Future<Response> getSchools(User user) async {
  final url = Uri.parse('$BASE_URL/users/@me/schools');
  final headers = {
    "Content-type": "application/json",
    'Authorization': user.authToken!
  };
  final response = await get(url, headers: headers);
  return Response(response.statusCode, jsonDecode(response.body));
}

Future<Response> getChannelsInSchool(User user, SchoolInfo school) async {
  final url = Uri.parse('$BASE_URL/schools/${school.id}/channels');
  final headers = {
    "Content-type": "application/json",
    'Authorization': user.authToken!
  };
  final response = await get(url, headers: headers);
  return Response(response.statusCode, jsonDecode(response.body));
}

Future<Response> getMessagesInChannel(
    User user, SchoolInfo school, ChannelInfo channel) async {
  final url = Uri.parse(
      '$BASE_URL/schools/${school.id}/channels/${channel.id}/messages');
  final headers = {'Authorization': user.authToken!};
  final response = await get(url, headers: headers);
  print(response.body);
  return Response(response.statusCode, jsonDecode(response.body));
}

Future<Response> sendMessageToChannel(
    User user, SchoolInfo school, ChannelInfo channel, String content) async {
  final url = Uri.parse(
      '$BASE_URL/schools/${school.id}/channels/${channel.id}/messages');
  final headers = {
    "Content-Type": "application/json",
    "Authorization": user.authToken!
  };
  final json = {"content": content};
  final response = await put(url, headers: headers, body: jsonEncode(json));
  return Response(response.statusCode, jsonDecode(response.body));
}

Future<Response> signupUser(String email, String password, String firstName,
    String lastName, String? middleInitial) async {
  final url = Uri.parse('$BASE_URL/auth/users/create');
  final headers = {"Content-type": "application/json"};
  final data = {
    'email': email,
    'password': password,
    'first_name': firstName,
    'last_name': lastName,
    'middle_initial': middleInitial
  };
  final json = jsonEncode(data);
  final response = await post(url, headers: headers, body: json);
  return Response(response.statusCode, jsonDecode(response.body));
}

Future<Response> joinViaCode(User user, String code) async {
  final url = Uri.parse('$BASE_URL/schools/join/$code');
  final headers = {
    "Content-type": "application/json",
    "Authorization": user.authToken!
  };
  final response = await put(url, headers: headers);
  return Response(response.statusCode, jsonDecode(response.body));
}

Future<Response> createSchool(User user, String name, String? shortName) async {
  final url = Uri.parse('$BASE_URL/schools/create');
  final headers = {
    "Content-type": "application/json",
    "Authorization": user.authToken!
  };
  final data = {'name': name, 'short_name': shortName};
  final json = jsonEncode(data);
  final response = await post(url, headers: headers, body: json);
  return Response(response.statusCode, jsonDecode(response.body));
}

void loadSchools(AppStateModel state) async {
  final res = await getSchools(state.user!);
  if (res.code == 200) {
    final schools = res.data as List<dynamic>;
    state.clearSchools();
    for (var school in schools) {
      state.addSchool(SchoolInfo.from(school));
      final res =
          await getChannelsInSchool(state.user!, SchoolInfo.from(school));
      if (res.code == 200) {
        final channels = res.data as List<dynamic>;
        for (var channel in channels) {
          state.addChannel(school['id'], ChannelInfo.from(channel));
        }
      }
    }
  }
}
