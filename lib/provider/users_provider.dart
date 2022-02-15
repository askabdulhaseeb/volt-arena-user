import 'package:flutter/material.dart';
import 'package:volt_arena/database/user_local_data.dart';
import 'package:volt_arena/models/users.dart';

class UserProvider extends ChangeNotifier {
  List<AppUserModel> _users = <AppUserModel>[];
  String search = '';

  void onSearch(String data) {
    search = data;
    notifyListeners();
  }

  List<AppUserModel> users() {
    if (search.isEmpty) {
      return _users;
    }
    final List<AppUserModel> _searched = [];
    for (AppUserModel element in _users) {
      if (element.id != UserLocalData.getUserUID) {
        if (element.name?.toLowerCase().contains(search.toLowerCase()) ??
            false) {
          _searched.add(element);
        }
      }
    }
    return _searched;
  }

  void addUsers(List<AppUserModel> data) {
    _users = data;
    _users.removeWhere((element) => element.id == UserLocalData.getUserUID);
    notifyListeners();
  }
}
