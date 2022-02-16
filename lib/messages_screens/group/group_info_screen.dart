import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/database/auth_methods.dart';
import 'package:volt_arena/enums/messages/role_in_chat_group.dart';
import 'package:volt_arena/models/group_chat_participant.dart';
import 'package:volt_arena/models/users.dart';
import 'package:volt_arena/widget/tools/circular_profile_image.dart';
import '../../provider/group_chat_provider.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GroupChatProvider _provider = Provider.of<GroupChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(_provider.groupChat?.name ?? '-'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 15 / 8,
                  child: _provider.groupChat?.imageURL == null ||
                          _provider.groupChat?.imageURL == ''
                      ? Container(
                          color: Colors.grey,
                          child: const FittedBox(
                            child: Icon(Icons.group),
                          ),
                        )
                      : Image.network(
                          _provider.groupChat?.imageURL ?? '',
                          fit: BoxFit.cover,
                        ),
                ),
              ],
            ),
            _TabableTextBox(
              title: _provider.groupChat?.name ?? '-',
              onTap: () {},
            ),
            _TabableTextBox(
              title: _provider.groupChat?.description ?? '-',
              onTap: () {},
              placeholder: 'Add a decription here',
            ),
            const SizedBox(width: 16),
            Text(
              'Total Members: ${_provider.groupChat?.participants?.length.toString() ?? "0"}',
              style: const TextStyle(color: Colors.grey),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 300),
              child: ListView.builder(
                itemCount: _provider.groupChat?.participantsDetail?.length ?? 0,
                itemBuilder: (_, int index) => _ParticipantTile(
                  participant:
                      _provider.groupChat?.participantsDetail?[index] ??
                          GroupChatParticipant(
                            user: AuthMethod.uid,
                            role: GroupParticipantRoleTypeEnum.MEMBER,
                          ),
                  user: _provider.userInfo(
                    uid: _provider.groupChat?.participantsDetail?[index].user ??
                        AuthMethod.uid,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({
    required this.participant,
    required this.user,
    Key? key,
  }) : super(key: key);
  final GroupChatParticipant participant;
  final AppUserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      minLeadingWidth: 10,
      leading: CircularProfileImage(imageURL: user.imageUrl ?? '', radious: 24),
      title: Text(user.name ?? 'issue while fetching'),
      subtitle: Text(user.email ?? 'issue while fetching'),
      trailing: Text(
        GroupParticipantRoleTypeConverter.formEnum(participant.role)
            .toLowerCase(),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class _TabableTextBox extends StatelessWidget {
  const _TabableTextBox({
    required this.title,
    required this.onTap,
    this.placeholder,
    Key? key,
  }) : super(key: key);
  final String title;
  final VoidCallback onTap;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: (title.isEmpty)
          ? Text(
              placeholder ?? '',
              style: const TextStyle(color: Colors.grey),
            )
          : Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
    );
  }
}
