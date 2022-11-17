import 'package:chat_app_groupie/helper/helper_functions.dart';
import 'package:chat_app_groupie/models/user_model.dart';
import 'package:chat_app_groupie/service/auth_service.dart';
import 'package:chat_app_groupie/widgets/side_navigation_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel user = UserModel();
  AuthService authService = AuthService();
  Stream? groups;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: SideNavigationWidget(
        currentPage: AppCurrentPage.profile,
        user: user,
        authService: authService,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 320.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/three.png"),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.fullName,
                                  style: const TextStyle(fontSize: 27.0),
                                  softWrap: false,
                                  maxLines: 2, // new
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.email,
                                  style: const TextStyle(fontSize: 14.0),
                                  softWrap: false,
                                  maxLines: 2, // new
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 80.0,
                  left: (MediaQuery.of(context).size.width / 2.0) - 60.0,
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/sit.jpg"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getUser() async {
    await HelperFunctions.getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }
}
