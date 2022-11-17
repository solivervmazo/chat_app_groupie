import 'package:chat_app_groupie/pages/auth/login_page.dart';
import 'package:chat_app_groupie/service/auth_service.dart';
import 'package:flutter/material.dart';

class LogoutDialogWidget extends StatelessWidget {
  const LogoutDialogWidget({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to log out?"),
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
            await authService.signOut().whenComplete(() {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            });
          },
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
