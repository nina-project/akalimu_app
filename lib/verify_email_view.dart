import 'package:akalimu/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify")),
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text(
                "Verify Email",
                style: TextStyle(backgroundColor: Colors.teal),
              ))
        ],
      ),
    );
  }
}
