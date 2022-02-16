import 'package:flutter/material.dart';
import '../../database/auth_methods.dart';
import '../../models/message.dart';
import '../../utilities/utilities.dart';

class PersonalMessageTile extends StatelessWidget {
  const PersonalMessageTile({
    required this.message,
    required this.displayName,
    required this.boxWidth,
    Key? key,
  }) : super(key: key);
  final Message message;
  final String displayName;
  final double boxWidth;
  @override
  Widget build(BuildContext context) {
    final bool isMe = AuthMethod.uid == message.sendBy;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft:
                  isMe ? const Radius.circular(14) : const Radius.circular(0),
            ),
            color: isMe ? Theme.of(context).primaryColor : Colors.grey.shade300,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: boxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 4),
                (isMe)
                    ? const SizedBox()
                    : Text(
                        displayName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                const SizedBox(height: 2),
                Text(
                  message.message,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: (isMe) ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      Utilities.timeInDigits(message.timestamp),
                      style: TextStyle(
                        color: (isMe) ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
