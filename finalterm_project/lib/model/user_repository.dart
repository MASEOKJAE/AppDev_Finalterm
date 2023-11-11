import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:flutter/material.dart';

class UserRepository extends ChangeNotifier {
  static UserModel? user;

  static void login(UserModel u) => user = u;
  static void logout() => user = null;

  final _users = <UserModel>[];

  Future loadAllFromDatabase() async {
    _users.clear();
    var collection = await FirebaseFirestore.instance.collection('users').get();

    for (var doc in collection.docs) {
      _users.add(UserModel.fromJson(doc.id, doc.data()));
    }
    notifyListeners();
  }

  UserModel getUser(String uid) {
    return _users.firstWhere((user) => user.uid == uid);
  }
}