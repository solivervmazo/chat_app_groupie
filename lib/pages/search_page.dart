import 'package:chat_app_groupie/helper/helper_functions.dart';
import 'package:chat_app_groupie/models/user_model.dart';
import 'package:chat_app_groupie/pages/chat_page.dart';
import 'package:chat_app_groupie/service/db_service.dart';
import 'package:chat_app_groupie/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchResultSnapshots;
  bool hasUserSearch = false;
  UserModel user = UserModel();
  bool userIsJoined = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Search group"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autocorrect: true,
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Start searching...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        40,
                      ),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : groupList()
        ],
      ),
    );
  }

  initiateSearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DbService()
          .searchGroupByName(groupName: searchController.text)
          .then((value) {
        setState(() {
          searchResultSnapshots = value;
          isLoading = false;
          hasUserSearch = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshots!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                fullName: user.fullName,
                groupId: searchResultSnapshots!.docs[index]["groupId"],
                groupName: searchResultSnapshots!.docs[index]["groupName"],
                adminName: searchResultSnapshots!.docs[index]["admin"],
              );
            },
          )
        : Container();
  }

  Widget groupTile({
    required String fullName,
    required String groupId,
    required String groupName,
    required String adminName,
  }) {
    isUserJoined(
      fullName: fullName,
      groupId: groupId,
      groupName: groupName,
      admin: adminName,
    );
    return ListTile(
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "Admin: ${getNameFromString(adminName)}",
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      dense: true,
      trailing: userIsJoined
          ? ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade300,
              ),
              onPressed: () async {
                await DbService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .toggleGroupJoin(
                  fullName: fullName,
                  groupId: groupId,
                  groupName: groupName,
                );
                if (userIsJoined) {
                  setState(() {
                    userIsJoined = !userIsJoined;
                  });
                }
                showSnackbar(
                  context,
                  Colors.red,
                  "You have left group",
                );
              },
              icon: const Icon(
                // <-- Icon
                Icons.exit_to_app,
                size: 24.0,
              ),
              label: const Text('Leave'), // <-- Text
            )
          : ElevatedButton.icon(
              onPressed: () async {
                await DbService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .toggleGroupJoin(
                  fullName: fullName,
                  groupId: groupId,
                  groupName: groupName,
                );
                if (userIsJoined) {
                  setState(() {
                    userIsJoined = !userIsJoined;
                  });
                }
                showSnackbar(
                  context,
                  Colors.green,
                  "Successfully joined group",
                );
                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    nextScreen(
                        context,
                        ChatPage(
                          groupId: groupId,
                          groupName: groupName,
                          fullName: fullName,
                        ));
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.9),
              ),
              icon: const Icon(
                // <-- Icon
                Icons.door_front_door,
                size: 24.0,
              ),
              label: const Text('Join'), // <-- Text
            ),
    );
  }

  isUserJoined({
    required String fullName,
    required String groupId,
    required String groupName,
    required String admin,
  }) async {
    return await DbService(uid: FirebaseAuth.instance.currentUser!.uid)
        .isUserJoined(
      groupName: groupName,
      groupId: groupId,
      fullName: fullName,
    )
        .then((value) {
      setState(() {
        userIsJoined = value;
      });
    });
  }

  getCurrentUser() async {
    await HelperFunctions.getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }
}
