import 'package:flutter/material.dart';
import 'package:volt_arena/database/user_local_data.dart';
import 'package:volt_arena/models/users.dart';
import 'package:volt_arena/utilities/custom_images.dart';

import '../../database/chat_api.dart';
import '../../messages_screens/personal/personal_chat_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.user, Key? key}) : super(key: key);
  static const String routeName = '/ProfileScreen';
  final AppUserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                child: (user.imageUrl == '' || user.imageUrl == null)
                    ? Image.asset(CustomImages.icon, fit: BoxFit.cover)
                    : Image.network(
                        user.imageUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.name ?? 'fetching issue',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              user.email ?? 'fetching issue',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Member since: ${user.joinedAt ?? 'fetching issue'}',
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                final String _chatID =
                    ChatAPI.getChatID(othersUID: user.id ?? '');
                Navigator.of(context).push(
                  MaterialPageRoute<PersonalChatScreen>(
                    builder: (BuildContext context) => PersonalChatScreen(
                      otherUser: user,
                      chatID: _chatID,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Message',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
