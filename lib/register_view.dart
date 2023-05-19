import 'dart:developer';

import 'package:akalimu/auth_serviceg.dart';
import 'package:akalimu/services/auth/auth_exceptions.dart';
import 'package:akalimu/services/auth/auth_service.dart';
import 'package:akalimu/utilities/dialogs/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:akalimu/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(hintText: "Enter your Email"),
              keyboardType: TextInputType.emailAddress,
              controller: _email,
            ),
            TextFormField(
              decoration:
                  const InputDecoration(hintText: "Enter your Password"),
              obscureText: true,
              // autocorrect: false,
              // enableSuggestions: false,
              controller: _password,
            ),
            TextButton(
              onPressed: () async {
                try {
                  AuthService.firebase().createUser(
                    email: _email.text,
                    password: _password.text,
                  );
                  AuthService.firebase().sendEmailVerification();
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Weak password',
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'Email already in use',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'This is an invalid email address',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Failed to Register',
                  );
                }
              },
              child: const Text("Register"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text("Registered? Login Here")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(verifyRoute);
                },
                child: const Text("verify")),
            TextButton(
                onPressed: () {
                  AuthServices().signInWithGoogle();
                  Navigator.of(context).pushNamed(mainPageRoute);
                },
                child: const Text("Google Sign In"))
          ],
        ),
      ),
    );
  }
}
