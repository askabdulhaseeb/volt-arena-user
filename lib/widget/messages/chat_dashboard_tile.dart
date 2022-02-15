import 'package:flutter/material.dart';
import 'package:volt_arena/models/users.dart';
import 'package:volt_arena/widget/tools/circular_profile_image.dart';
import '../../database/auth_methods.dart';
import '../../database/user_api.dart';
import '../../messages_screens/personal/personal_chat_screen.dart';
import '../../models/chat.dart';
import '../../utilities/utilities.dart';
import '../show_loading.dart';

class ChatDashboardTile extends StatelessWidget {
  const ChatDashboardTile({required this.chat, Key? key}) : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUserModel?>(
      future: UserAPI().getInfo(
          uid: chat.persons[chat.persons
              .indexWhere((String element) => element != AuthMethod.uid)]),
      builder: (_, AsyncSnapshot<AppUserModel?> snapshot) {
        if (snapshot.hasError) {
          return const _ErrorWidget();
        } else {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShowLoading();
          } else {
            final AppUserModel _user = snapshot.data!;
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<PersonalChatScreen>(
                    builder: (_) => PersonalChatScreen(
                        otherUser: _user, chatID: chat.chatID),
                  ),
                );
              },
              dense: true,
              minLeadingWidth: 10,
              leading: CircularProfileImage(
                imageURL: _user.imageUrl ?? '',
                radious: 24,
              ),
              title: Text(
                _user.name ?? 'issue',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                chat.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                Utilities.timeInDigits(chat.timestamp),
                style: const TextStyle(fontSize: 12),
              ),
            );
          }
        }
      },
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const <Widget>[
          Text(
            'Some thing goes wrong',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
