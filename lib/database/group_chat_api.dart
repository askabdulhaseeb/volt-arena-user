import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/message.dart';
import '../models/group_chat.dart';
import '../widget/tools/custom_toast.dart';
import 'auth_methods.dart';

class GroupChatAPI {
  static const String _colloction = 'chat_groups';
  static const String _subColloction = 'messages';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  //
  // Groups
  //
  Future<bool> createGroup(GroupChat group) async {
    try {
      Map<String, dynamic> _mapp = group.createGroup();
      await _instance.collection(_colloction).doc(_mapp['group_id']).set(_mapp);
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
      return false;
    }
    return true;
  }

  Future<List<GroupChat>> getGroups() async {
    List<GroupChat> _groups = <GroupChat>[];
    try {
      final Stream<QuerySnapshot<Map<String, dynamic>>> docs = _instance
          .collection(_colloction)
          .orderBy('timestamp', descending: true)
          .where('participants', arrayContains: AuthMethod.uid)
          .snapshots();
      docs.forEach((QuerySnapshot<Map<String, dynamic>> snap) {
        for (DocumentSnapshot<Map<String, dynamic>> element in snap.docs) {
          _groups.add(GroupChat.fromDoc(element));
        }
      });
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
    return _groups;
  }

  Future<void> sendMessage({
    required GroupChat group,
    required Message messages,
  }) async {
    try {
      // ignore: always_specify_types
      Future.wait([
        _instance
            .collection(_colloction)
            .doc(group.groupID)
            .collection(_subColloction)
            .doc(messages.messageID)
            .set(messages.toMap()),
        _instance
            .collection(_colloction)
            .doc(group.groupID)
            .update(group.newMessage()),
      ]);
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<void> updateParticipent(GroupChat groupChat) async {
    try {
      await _instance
          .collection(_colloction)
          .doc(groupChat.groupID)
          .update(groupChat.updateParticipant());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<List<Message>> getMessages({required String groupID}) async {
    List<Message> _message = <Message>[];
    try {
      final Stream<QuerySnapshot<Map<String, dynamic>>> docs = _instance
          .collection(_colloction)
          .doc(groupID)
          .collection(_subColloction)
          .orderBy('timestamp', descending: true)
          .snapshots();
      docs.forEach((QuerySnapshot<Map<String, dynamic>> snap) {
        for (DocumentSnapshot<Map<String, dynamic>> element in snap.docs) {
          _message.add(Message.fromDoc(element));
        }
      });
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
    return _message;
  }

  Future<String?> uploadGroupImage({required File file}) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('Groups/Icons/${DateTime.now().microsecondsSinceEpoch}')
          .putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
