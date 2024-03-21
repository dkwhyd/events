import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:events/models/even_detail.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
      ),
      body: EventList(),
    );
  }
}

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List details = [];

  @override
  void initState() {
    if (mounted) {
      getDetailList().then((data) {
        setState(() {
          details = data;
        });
      });
    }

    getDetailList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: details != null ? details.length : 0,
        itemBuilder: (context, position) {
          String sub =
              "Date: ${details[position].date} - Start: ${details[position].startTime}- End: ${details[position].endTime}";
          return ListTile(
            title: Text(details[position].description),
            subtitle: Text(sub),
          );
        });
  }

  Future getDetailList() async {
    var data = await db.collection('event_details').get();

    details = data.docs.map((e) => EventDetail.fromMap(e)).toList();

    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
      print(detail.id);
      i++;
    });
    return details;
  }
}
