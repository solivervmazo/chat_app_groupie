import 'package:chat_app_groupie/helper/helper_functions.dart';
import 'package:chat_app_groupie/pages/home_page.dart';
import 'package:chat_app_groupie/service/auth_service.dart';
import 'package:chat_app_groupie/service/db_service.dart';
import 'package:chat_app_groupie/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfoWidget extends StatefulWidget {
  const GroupInfoWidget({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminName,
    required this.fullName,
  });

  final String groupId;
  final String groupName;
  final String adminName;
  final String fullName;

  @override
  State<GroupInfoWidget> createState() => _GroupInfoWidgetState();
}

class _GroupInfoWidgetState extends State<GroupInfoWidget> {
  Stream? members;
  AuthService authService = AuthService();

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Group information"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Leave group"),
                    content:
                        const Text("Are you sure you want to leave the group?"),
                    actions: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await DbService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .toggleGroupJoin(
                            fullName: widget.fullName,
                            groupId: widget.groupId,
                            groupName: widget.groupName,
                          );
                          nextScreenReplace(context, const HomePage());
                          showSnackbar(
                            context,
                            Colors.red,
                            "You have left group",
                          );
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
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
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text("Admin: ${getNameFromString(widget.adminName)}"),
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  getMembers() async {
    DbService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(
      groupId: widget.groupId,
    )
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null &&
              snapshot.data['members'].length != 0) {
            return ListView.builder(
              itemCount: snapshot.data["members"].length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getNameFromString(snapshot.data["members"][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getNameFromString(snapshot.data["members"][index]),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            getIdFromString(snapshot.data["members"][index]),
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No members"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}
