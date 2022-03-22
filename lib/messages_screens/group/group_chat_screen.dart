import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/widget/tools/circular_profile_image.dart';
import '../../../../../database/auth_methods.dart';
import '../../../../../database/group_chat_api.dart';
import '../../../../../enums/messages/message_type_enum.dart';
import '../../../../../models/group_chat.dart';
import '../../../../../models/message.dart';
import '../../../../../utilities/utilities.dart';
import '../../database/user_local_data.dart';
import '../../provider/group_chat_provider.dart';
import '../../widget/messages/chat_textformfield.dart';
import '../../widget/messages/personal_message_tile.dart';
import 'group_info_screen.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({Key? key}) : super(key: key);
  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    GroupChatProvider _provider = Provider.of<GroupChatProvider>(context);
    return Scaffold(
      appBar: _appBar(_provider.groupChat!),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('chat_groups')
                    .doc(_provider.groupChat!.groupID)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (_,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    default:
                      if (snapshot.hasData) {
                        List<Message> _messages = <Message>[];
                        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                            in snapshot.data!.docs) {
                          _messages.add(Message.fromDoc(doc));
                        }
                        return (_messages.isEmpty)
                            ? SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Text(
                                      'Say Hi!',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'and start conversation with Group Members',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: _messages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Consumer<GroupChatProvider>(
                                      builder: (_, persons, __) =>
                                          PersonalMessageTile(
                                            boxWidth: _size.width * 0.65,
                                            message: _messages[index],
                                            displayName: persons
                                                    .userInfo(
                                                        uid: _messages[index]
                                                                .sendBy ??
                                                            AuthMethod.uid)
                                                    .name ??
                                                '',
                                          ));
                                },
                              );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: const <Widget>[
                            Icon(Icons.report, color: Colors.grey),
                            Text(
                              'Some issue found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
            ),
            ChatTestFormField(
                controller: _text,
                onSendPressed: () async {
                  int _time = DateTime.now().microsecondsSinceEpoch;
                  _provider.groupChat!.lastMessage = _text.text;
                  _provider.groupChat!.timestamp = _time;
                  _provider.groupChat!.type = MessageTypeEnum.TEXT;
                  await GroupChatAPI().sendMessage(
                    group: _provider.groupChat!,
                    messages: Message(
                      messageID: _time.toString(),
                      message: _text.text.trim(),
                      timestamp: _time,
                    ),
                  );
                  _text.clear();
                }),
            SizedBox(height: Utilities.padding),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(GroupChat group) {
    return AppBar(
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<GroupInfoScreen>(
            builder: (_) => const GroupInfoScreen(),
          ));
        },
        child: Row(
          children: <Widget>[
            CircularProfileImage(
              imageURL: group.imageURL ?? '',
              radious: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    group.name ?? 'issue',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Tab here for group info',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
