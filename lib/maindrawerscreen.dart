import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:akalimu/main_ui_controller.dart';
//import 'package:gighub/auth_service.dart';
//import 'package:gighub/profile_user.dart';
//import 'package:provider/provider.dart';
import 'package:akalimu/payments_screen.dart';
import 'package:akalimu/profilescreen.dart';

import 'aboutscreen.dart';
import 'helpscreen.dart';

class MainDrawer extends StatefulWidget {
  final String userImage;

  const MainDrawer({super.key, required this.userImage});
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  User? user = FirebaseAuth.instance.currentUser;

  static const IconData verified =
      IconData(0xe699, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return StreamBuilder<DocumentSnapshot>(
        stream: users.doc(user!.uid).snapshots(),
        builder: (ctx, streamSnapshot) {
          return Drawer(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFF163a96),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 30,
                          ),
                          child: CircleAvatar(
                            radius: 40.0,
                            child: ClipOval(
                              child: Image.network(
                                (user?.photoURL).toString(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                          child: Row(children: [
                            Text(
                              (user?.displayName).toString(),
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            // Text(streamSnapshot.data!['lastname'],
                            //     style: const TextStyle(fontSize: 22)),
                            IconButton(
                              onPressed: () {},
                              icon: new Icon(Icons.verified),
                              color: Colors.white,
                              //highlightColor: Colors.white,
                            ),
                          ]),
                        ),
                        // Text(
                        //   (user?.phoneNumber).toString(),
                        //   style: const TextStyle(
                        //     fontSize: 18,
                        //     color: Color(0xFF163a96),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF163a96),
                  ),
                  title: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    child: const Text('Profile',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.payment, color: Color(0xFF163a96)),
                  title: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Payments()));
                    },
                    child: const Text('Payments',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF163a96)),
                  title: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Help()));
                    },
                    child: const Text('Help',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading:
                      const Icon(Icons.info_outline, color: Color(0xFF163a96)),
                  title: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const About()));
                    },
                    child: const Text('About',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.logout_outlined,
                      color: Color(0xFF163a96)),
                  title: TextButton(
                    onPressed: () async {
                      PopupMenuButton<MenuAction>(
                        onSelected: (value) async {
                          await showDialogBox(context);
                        },
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem<MenuAction>(
                              value: MenuAction.logout,
                              child: Text("logout"),
                            ),
                          ];
                        },
                      );

                      //await authService.signOut();
                    },
                    child: const Text('Logout',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

Future<bool> showDialogBox(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Do you want to logout"),
          actions: [
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/login/", (route) => false);
                  log("true");
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  log('false');
                },
                child: const Text("No"))
          ],
        );
      }).then((value) => value ?? false);
}
