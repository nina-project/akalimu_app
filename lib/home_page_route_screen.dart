import 'dart:developer';
import 'package:akalimu/mainappscreen.dart';
import 'package:akalimu/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:akalimu/login_view_screen.dart';
//import 'package:akalimu/main_ui_controller.dart';
import 'package:akalimu/register_view.dart';
import 'firebase_options.dart';

class HomePageRoute extends StatelessWidget {
  const HomePageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user?.isEmailVerified ?? false) {
                log(user.toString());
                return const MainPage();
              } else {
                log(user.toString());
                return const RegisterPage();
              }
            default:
              const Text('Done');
          }
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        });
  }
}
