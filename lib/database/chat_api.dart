import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volt_arena/database/user_local_data.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../widget/tools/custom_toast.dart';

class ChatAPI {
  static const String _colloction = 'chats';
  static const String _subColloction = 'messages';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  static String getChatID({required String othersUID}) {
    int _isGreaterThen = UserLocalData.getUserUID.compareTo(othersUID);
    if (_isGreaterThen > 0) {
      return '${UserLocalData.getUserUID}-chats-$othersUID';
    } else {
      return '$othersUID-chats-${UserLocalData.getUserUID}';
    }
  }

  Future<void> sendMessage(Chat chat, Message messages) async {
    // ignore: always_specify_types
    try {
      // ignore: always_specify_types
      Future.wait([
        _instance
            .collection(_colloction)
            .doc(chat.chatID)
            .collection(_subColloction)
            .doc(messages.messageID)
            .set(messages.toMap()),
        _instance.collection(_colloction).doc(chat.chatID).set(chat.toMap()),
      ]);
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<Chat?> fetchChat(String chatID) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_colloction).doc(chatID).get();
    if (!doc.exists) return null;
    Chat _chat = Chat.fromDoc(doc);
    return _chat;
  }

  Future<List<Chat>> fetchChats(String uid) async {
    List<Chat> _chat = <Chat>[];
    try {
      final Stream<QuerySnapshot<Map<String, dynamic>>> docs = _instance
          .collection(_colloction)
          .orderBy('timestamp', descending: true)
          .where('persons', arrayContains: uid)
          .snapshots();
      docs.forEach((QuerySnapshot<Map<String, dynamic>> snap) {
        for (DocumentSnapshot<Map<String, dynamic>> element in snap.docs) {
          _chat.add(Chat.fromDoc(element));
        }
      });
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
    return _chat;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchMessages(
      String chatID) async {
    return _instance
        .collection(_colloction)
        .doc(chatID)
        .collection(_subColloction)
        .orderBy('timestamp', descending: true)
        .snapshots();
    // List<Messages> _messages = <Messages>[];
    // // print(docs.docs);
    // for (DocumentSnapshot<Map<String, dynamic>> doc in docs.docs) {
    //   _messages.add(Messages.fromDoc(doc));
    // }
    // return _messages;
  }
}
