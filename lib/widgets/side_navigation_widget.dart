import 'package:chat_app_groupie/models/user_model.dart';
import 'package:chat_app_groupie/pages/home_page.dart';
import 'package:chat_app_groupie/pages/profile_page.dart';
import 'package:chat_app_groupie/service/auth_service.dart';
import 'package:chat_app_groupie/widgets/logout_dialog_widget.dart';
import 'package:chat_app_groupie/widgets/side_navigation_item_widget.dart';
import 'package:flutter/material.dart';

enum AppCurrentPage {
  groups,
  profile,
}

class SideNavigationWidget extends StatefulWidget {
  const SideNavigationWidget({
    super.key,
    required this.currentPage,
    required this.user,
    required this.authService,
  });

  final AppCurrentPage currentPage;
  final UserModel user;
  final AuthService authService;

  @override
  State<SideNavigationWidget> createState() => _SideNavigationStateWidget();
}

class _SideNavigationStateWidget extends State<SideNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(
          bottom: 50.0,
        ),
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountEmail: Text(
              widget.user.email,
            ),
            accountName: Text(
              widget.user.fullName,
            ),
            currentAccountPicture: const Icon(
              Icons.account_circle,
              size: 90.0,
              color: Colors.white,
            ),
          ),
          SideNavigationItemWidget(
            selected: widget.currentPage == AppCurrentPage.groups,
            title: "Groups",
            icon: Icons.group,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          SideNavigationItemWidget(
            selected: widget.currentPage == AppCurrentPage.profile,
            title: "Profile",
            icon: Icons.people,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          SideNavigationItemWidget(
            selected: false,
            title: "Logout",
            icon: Icons.exit_to_app,
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return LogoutDialogWidget(
                    authService: widget.authService,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
