class Favorite {
  String? _id;
  String? _eventId;
  String? _userId;

  Favorite(this._id, this._eventId, this._userId);

  Favorite.map(snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    _id = snapshot.id;
    _eventId = data['eventId'];
    _userId = data['userId'];
  }

  String? get eventId => _eventId;
  String? get userId => _userId;

  String? get id => _id;

  set id(String? value) => _id = value; // Setter for 'id'

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['eventId'] = _eventId;
    map['userId'] = _userId;
    return map;
  }
}
