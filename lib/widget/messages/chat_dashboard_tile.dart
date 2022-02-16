import 'package:flutter/material.dart';
import 'package:volt_arena/models/users.dart';
import 'package:volt_arena/widget/tools/circular_profile_image.dart';
import '../../messages_screens/personal/personal_chat_screen.dart';
import '../../models/chat.dart';
import '../../utilities/utilities.dart';

class ChatDashboardTile extends StatelessWidget {
  const ChatDashboardTile({required this.chat, required this.user, Key? key})
      : super(key: key);
  final Chat chat;
  final AppUserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<PersonalChatScreen>(
            builder: (_) =>
                PersonalChatScreen(otherUser: user, chatID: chat.chatID),
          ),
        );
      },
      dense: true,
      minLeadingWidth: 10,
      leading: CircularProfileImage(
        imageURL: user.imageUrl ?? '',
        radious: 24,
      ),
      title: Text(
        user.name ?? 'issue',
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