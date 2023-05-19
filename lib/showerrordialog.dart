import 'package:akalimu/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

Future<bool> showDialogBox(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Do you want to logout"),
          actions: [
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/homepage/", (route) => false);
                print("true");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Color(0xFF163a96),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                print('false');
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Color(0xFF163a96),
                ),
              ),
            )
          ],
        );
      }).then((value) => value ?? false);
}
