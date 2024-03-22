import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/even_detail.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(
          child: Text(
            'Events',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: const EventList(),
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
        itemCount: details.length,
        itemBuilder: (context, position) {
          String sub =
              "Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}";
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
    // print("Total data: ${details.length}");
    for (var detail in details) {
      detail.id = data.docs[i].id;
      i++;
    }
    return details;
  }
}
