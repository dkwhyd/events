import 'package:events/screens/event_list.dart';

import 'package:events/screens/login_screens.dart';
import 'package:events/shared/authentication.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  final String uid;
  const EventScreen({
    required this.uid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Authentication auth = Authentication();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Center(
            child: Text(
              'Events',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                semanticLabel: 'Logout',
              ),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            auth.signOut().then((result) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (Route<dynamic> route) => false,
                              );
                            });
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: EventList(
                uid: uid,
              ),
            ),
            // Expanded(
            //   child: FavoriteList(uid: uid),
            // ),
          ],
        ));
  }
}
