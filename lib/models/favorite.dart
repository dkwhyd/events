class Favorite {
  String? id;
  String? _eventId;
  String? _userId;

  Favorite(this.id, this._eventId, this._userId);

  Favorite.map(snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    id = snapshot.id;
    _eventId = data['eventId'];
    _userId = data['userId'];
  }

  String? get eventId => _eventId;
  String? get userId => _userId; 

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['eventId'] = _eventId;
    map['userId'] = _userId;
    return map;
  }
}
