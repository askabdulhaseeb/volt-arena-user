import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/database/user_api.dart';
import 'package:volt_arena/models/users.dart';
import 'package:volt_arena/provider/group_chat_provider.dart';
import 'package:volt_arena/widget/show_loading.dart';
import '../../../../enums/messages/message_tabbar_enum.dart';
import '../provider/message_page_provider.dart';
import 'group/group_chat_dashboard.dart';
import 'personal/personal_chat_dashboard.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);
  static const String routeName = '/MessageScreen';

  @override
  Widget build(BuildContext context) {
    MessagePageProvider _page = Provider.of<MessagePageProvider>(context);
    GroupChatProvider _chat = Provider.of<GroupChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: FutureBuilder<List<AppUserModel>>(
          future: UserAPI().getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Facing some issues'));
            }
            if (snapshot.hasData) {
              _chat.addUsers(snapshot.data ?? <AppUserModel>[]);
              return Column(
                children: <Widget>[
                  _TabBar(page: _page),
                  Expanded(
                      child: (_page.currentTab == MessageTabBarEnum.CHATS)
                          ? const PersonalChatDashboard()
                          : const GroupChatDashboaed()),
                ],
              );
            } else {
              return const ShowLoading();
            }
          }),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required MessagePageProvider page, Key? key})
      : _page = page,
        super(key: key);

  final MessagePageProvider _page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TabBarIconButton(
            icon: Icons.chat_outlined,
            title: 'Personal',
            isSelected: _page.currentTab == MessageTabBarEnum.CHATS,
            onTab: () {
              _page.updateTab(MessageTabBarEnum.CHATS);
            },
          ),
          Container(height: 30, width: 1, color: Colors.grey[200]),
          TabBarIconButton(
            icon: Icons.groups_rounded,
            title: 'Groups',
            isSelected: _page.currentTab == MessageTabBarEnum.GROUPS,
            onTab: () {
              _page.updateTab(MessageTabBarEnum.GROUPS);
            },
          ),
        ],
      ),
    );
  }
}

class TabBarIconButton extends StatelessWidget {
  const TabBarIconButton({
    required this.onTab,
    required this.icon,
    required this.title,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);
  final bool isSelected;
  final IconData icon;
  final String title;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    final Color? _color = isSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).iconTheme.color;
    return GestureDetector(
      onTap: onTab,
      child: Column(
        children: <Widget>[
          Icon(icon, color: _color),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: _color),
          ),
        ],
      ),
    );
  }
}
