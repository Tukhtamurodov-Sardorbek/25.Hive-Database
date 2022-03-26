import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hiveldb/models/user.dart';

class HiveService {
  static String DB_NAME = 'database';
  static Box box = Hive.box(DB_NAME);

  /// FOR A STRING
  Future<void> storeString (String str) async {
    box.put('String', str);
  }

  String loadString(){
    if(box.containsKey('String')){
      String str = box.get('String');
      return str;
    }
    return 'No data';
  }

  Future<void> removeString() async {
    box.delete('String');
  }

  /// FOR AN OBJECT
  Future<void> storeUser (User user) async {
    box.put('userModel', user.toJson());
  }

  User loadUser(){
    if(box.containsKey('userModel')){
      User user = User.fromJson(box.get('userModel'));
      return user;
    }
    return User(password: 'No data', email: 'No data');
  }

  Future<void> removeUser() async {
    box.delete('userModel');
  }

  /// FOR A LIST
  Future<void> storeUsers (List<User> users) async {
    // Object => Map => String
    List<String> stringList = users.map((user) => jsonEncode(user.toJson())).toList();
    await box.put('usersList', stringList);
  }

  List<User> loadUsers(){
    if(box.containsKey('usersList')){
      // String => Map => Object
      List<String> stringList = box.get('usersList');
      List<User> usersList = stringList.map((stringUser) => User.fromJson(jsonDecode(stringUser))).toList();
      return usersList;
    }
    return <User>[];
  }

  Future<void> removeUsers() async {
    await box.delete('usersList');
  }
}