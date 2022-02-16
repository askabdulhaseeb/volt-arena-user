import 'package:flutter/material.dart';
import 'package:volt_arena/database/auth_methods.dart';
import 'package:volt_arena/models/group_chat.dart';
import 'package:volt_arena/models/users.dart';

import '../enums/messages/role_in_chat_group.dart';
import '../models/group_chat_participant.dart';

class GroupChatProvider extends ChangeNotifier {
  List<AppUserModel> _users = <AppUserModel>[];
  GroupChat? groupChat;
  String search = '';

  void onSearch(String data) {
    search = data;
    notifyListeners();
  }

  AppUserModel userInfo({required String uid}) {
    return _users.firstWhere((element) => element.id == uid);
  }

  removeParticipent({required String uid}) {
    if (uid == AuthMethod.uid) return;
    if (uid == groupChat!.createdBy) return;
    groupChat!.participants!.remove(uid);
    groupChat!.participantsDetail?.removeWhere(
      (element) => element.user == uid,
    );
    notifyListeners();
  }

  addParticipent({required String uid}) {
    if (groupChat!.participants?.contains(uid) ?? true) return;
    groupChat!.participants?.add(uid);
    groupChat!.participantsDetail?.add(
      GroupChatParticipant(
        user: uid,
        role: GroupParticipantRoleTypeEnum.MEMBER,
        addedBy: AuthMethod.uid,
        invitationAccepted: true,
        isMute: false,
      ),
    );
    notifyListeners();
  }

  addAllParticipent() {
    if (_users.isEmpty) return;
    for (AppUserModel element in _users) {
      groupChat!.participants?.add(element.id!);
      groupChat!.participantsDetail?.add(
        GroupChatParticipant(
          user: element.id!,
          role: GroupParticipantRoleTypeEnum.MEMBER,
          addedBy: AuthMethod.uid,
          invitationAccepted: true,
          isMute: false,
        ),
      );
    }
    notifyListeners();
  }

  List<AppUserModel> users() {
    if (search.isEmpty) {
      return _users;
    }
    final List<AppUserModel> _searched = [];
    for (AppUserModel element in _users) {
      if (element.name?.toLowerCase().contains(search.toLowerCase()) ?? false) {
        _searched.add(element);
      }
    }
    return _searched;
  }

  void addUsers(List<AppUserModel> data) {
    _users = data;
  }
}
