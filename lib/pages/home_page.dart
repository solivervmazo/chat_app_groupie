import 'package:chat_app_groupie/helper/helper_functions.dart';
import 'package:chat_app_groupie/models/user_model.dart';
import 'package:chat_app_groupie/pages/search_page.dart';
import 'package:chat_app_groupie/service/auth_service.dart';
import 'package:chat_app_groupie/service/db_service.dart';
import 'package:chat_app_groupie/widgets/groups_tile_widget.dart';
import 'package:chat_app_groupie/widgets/side_navigation_widget.dart';
import 'package:chat_app_groupie/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel user = UserModel();
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                const SearchPage(),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: SideNavigationWidget(
        currentPage: AppCurrentPage.groups,
        authService: authService,
        user: user,
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Future getUser() async {
    await HelperFunctions.getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    await DbService(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  void popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Create a group",
            textAlign: TextAlign.left,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isLoading == true
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  : TextField(
                      onChanged: (value) {
                        setState(() {
                          groupName = value;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Group name",
                        prefixIcon: Icon(
                          Icons.group,
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                if (groupName.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  DbService(uid: FirebaseAuth.instance.currentUser!.uid)
                      .createGroup(
                        userName: user.fullName,
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        groupName: groupName,
                      )
                      .whenComplete(() => _isLoading = false);
                  Navigator.pop(context);
                  showSnackbar(
                      context, Colors.green, "Group created successfully.");
                } else {}
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
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["groups"] != null) {
            if (snapshot.data["groups"].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["groups"].length,
                itemBuilder: (context, index) {
                  return GroupstileWidget(
                      adminName: snapshot.data["fullName"],
                      groupId: getIdFromString(snapshot.data['groups'][index]),
                      groupName:
                          getNameFromString(snapshot.data['groups'][index]));
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
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

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => popUpDialog(context),
            child: Icon(
              Icons.add_circle,
              color: Colors.grey.shade700,
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "You have not joined any group, tap on the add icon to create one or search.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
