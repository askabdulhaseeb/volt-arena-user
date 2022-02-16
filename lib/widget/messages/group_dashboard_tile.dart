import 'package:flutter/material.dart';
import '../../messages_screens/group/group_chat_screen.dart';
import '../../models/group_chat.dart';
import '../../utilities/utilities.dart';
import '../tools/circular_profile_image.dart';

class GroupChatDashboardTile extends StatelessWidget {
  const GroupChatDashboardTile({required this.group, Key? key})
      : super(key: key);

  final GroupChat group;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<GroupChatScreen>(
            builder: (_) => const GroupChatScreen(),
          ),
        );
      },
      dense: true,
      leading: CircularProfileImage(imageURL: group.imageURL ?? ''),
      title: Text(
        group.name ?? 'Issue',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        group.lastMessage ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        Utilities.timeInDigits(group.timestamp!),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
