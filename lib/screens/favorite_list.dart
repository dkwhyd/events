import 'package:events/models/favorite.dart';
import 'package:events/shared/firestore_helper.dart';
import 'package:flutter/material.dart';

class FavoriteList extends StatefulWidget {
  final String uid;

  const FavoriteList({super.key, required this.uid});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  late List<Favorite> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  _loadFavorites() async {
    List<Favorite> userFavorites =
        await FireStoreHelper.getUserFavorite(widget.uid);

    if (mounted) {
      setState(() {
        favorites = userFavorites;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, position) {
        return ListTile(
          title: Text('Event ID: ${favorites[position].eventId}'),
          subtitle: Text('User ID: ${favorites[position].userId}'),
          // trailing: Text('Snapshot ID: ${favorites[position].id}'),
        );
      },
    );
  }
}
