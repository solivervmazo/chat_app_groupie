import 'package:chat_app_groupie/shared/constants.dart';
import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  labelStyle: const TextStyle(
    fontWeight: FontWeight.w300,
    color: Colors.black,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constants.primaryColor,
      width: 2,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constants.primaryColor,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Constants.primaryColor,
      width: 2,
    ),
  ),
);

void nextScreen(context, page) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void nextScreenReplace(context, page) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      backgroundColor: color,
      duration: const Duration(
        seconds: 4,
      ),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}
