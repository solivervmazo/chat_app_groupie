import 'package:chat_app_groupie/pages/chat_page.dart';
import 'package:chat_app_groupie/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupstileWidget extends StatefulWidget {
  const GroupstileWidget({
    super.key,
    required this.adminName,
    required this.groupId,
    required this.groupName,
  });

  final String adminName;
  final String groupId;
  final String groupName;

  @override
  State<GroupstileWidget> createState() => _GroupstileWidgetState();
}

class _GroupstileWidgetState extends State<GroupstileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              fullName: widget.adminName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.groupId,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
