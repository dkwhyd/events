import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  String? _id;
  String? _eventId;
  String? _userId;
  Favorite(this._id, this._eventId, this._userId);

  Favorite.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    _id = snapshot.id;
    _eventId = data['eventId'];
    _userId = data['userId'];
  }

  toMap() {
    Map map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['eventId'] = _eventId;
    map['userId'] = _userId;
    return map;
  }
}
