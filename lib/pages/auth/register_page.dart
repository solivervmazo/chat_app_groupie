import 'package:chat_app_groupie/helper/helper_functions.dart';
import 'package:chat_app_groupie/pages/auth/login_page.dart';
import 'package:chat_app_groupie/pages/home_page.dart';
import 'package:chat_app_groupie/service/auth_service.dart';
import 'package:chat_app_groupie/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 80.0,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Groupie",
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Create your account now to chat and explore",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Image.asset(
                        "assets/images/register.png",
                        height: MediaQuery.of(context).size.height * 0.30,
                        fit: BoxFit.cover,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Full name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            fullName = value;
                          });
                        },
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : "Please enter a name";
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => register(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text(
                            "Register",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreenReplace(
                                    context,
                                    LoginPage(),
                                  );
                                },
                              text: "Sign in here",
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(
        fullName: fullName,
        email: email,
        password: password,
      )
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(
            isUserLoggedIn: true,
          );
          await HelperFunctions.saveUserEmailSharedRef(
            email: email,
          );
          await HelperFunctions.saveUserFullNameSharedRef(
            fullName: fullName,
          ).then((value) {
            nextScreenReplace(
              context,
              const HomePage(),
            );
          });
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
