// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/even_detail.dart';
import 'package:events/models/favorite.dart';
// import 'package:events/screens/favorite_list.dart';
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
  List favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadDetails();
  }

  Future _loadFavorites() async {
    List userFavorites = await FireStoreHelper.getUserFavorite(widget.uid!);
    if (mounted) {
      setState(() {
        favorites = userFavorites;
      });
    }
  }

  Future<void> _loadDetails() async {
    QuerySnapshot data = await db.collection('event_details').get();
    if (mounted) {
      setState(() {
        details = data.docs.map((e) => EventDetail.fromMap(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (favorites == null) {
      return const CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: details.length,
      itemBuilder: (context, position) {
        String sub =
            "Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime} ";

        return ListTile(
          title: Text(details[position].description),
          subtitle: Text(sub),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: isUserFavorite(details[position].id) ? Colors.red : null,
            ),
            onPressed: () {
              toggleFavorite(details[position], position);
            },
          ),
        );
      },
    );
  }

  Future getDetailList() async {
    var data = await db.collection('event_details').get();
    details = data.docs.map((e) => EventDetail.fromMap(e)).toList();

    int i = 0;
    for (var detail in details) {
      detail.id = data.docs[i].id;
      i++;
    }
    return details;
  }

  void toggleFavorite(EventDetail detail, position) {
    Iterable<Favorite> data =
        favorites.where((item) => item.eventId == detail.id).cast<Favorite>();

    String idList = data.map((item) => item.id).join(', ');

    String itemId = detail.id!;
    if (isUserFavorite(itemId)) {
      FireStoreHelper.deleteFavorite(idList).then((_) {
        _loadFavorites();
      });
    } else {
      FireStoreHelper.addFavorite(detail, widget.uid!).then((_) {
        _loadFavorites();
      });
    }
  }

  bool isUserFavorite(String eventId) {
    // if (favorites.isEmpty) {
    //   return false;
    // }
    // for (int i = 0; i < favorites.length && i <= position; i++) {
    //   if (favorites[i].eventId.toString() == eventId) {
    //     return true;
    //   }
    // }
    // return false;
    return favorites.any((event) => event.eventId.toString() == eventId);
  }
}
