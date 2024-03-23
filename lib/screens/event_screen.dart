import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/even_detail.dart';
import 'package:events/screens/login_screens.dart';
import 'package:events/shared/authentication.dart';
import 'package:events/shared/firestore_helper.dart';
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
                          Navigator.of(context).pop(); // Tutup dialog
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
      body: EventList(
        uid: uid,
      ),
    );
  }
}

class EventList extends StatefulWidget {
  final String? uid;
  const EventList({
    required this.uid,
    super.key,
  });

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List details = [];

  @override
  void initState() {
    getDetailList().then((data) {
      setState(() {
        details = data;
      });
    });

    getDetailList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, position) {
          String sub =
              "Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}";
          return ListTile(
            title: Text(details[position].description),
            subtitle: Text(sub),
            trailing: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                toggleFavorite(details[position]);
              },
            ),
          );
        });
  }

  Future getDetailList() async {
    var data = await db.collection('event_details').get();

    details = data.docs.map((e) => EventDetail.fromMap(e)).toList();

    int i = 0;
    // print("Total data: ${details.length}");
    for (var detail in details) {
      detail.id = data.docs[i].id;
      i++;
    }
    return details;
  }

  void toggleFavorite(EventDetail ed) {
    FireStoreHelper.addFavorite(ed, widget.uid.toString());
  }
}
