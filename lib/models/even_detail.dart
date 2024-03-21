class EventDetail {
  String? id;
  String? _description;
  String? _date;
  String? _startTime;
  String? _endTime;
  String? _speaker;
  bool? _isFavorite;

  EventDetail(this.id, this._description, this._date, this._startTime,
      this._endTime, this._speaker, this._isFavorite);

  String? get description => _description;
  String? get date => _date;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get speaker => _speaker;
  bool? get isFavorite => _isFavorite;

  EventDetail.fromMap(object) {
    id = object.id;
    _description = object['description'];
    _date = object['date'];
    _startTime = object['start_time'];
    _endTime = object['end_time'];
    _speaker = object['speaker'];
    _isFavorite = object['is_favorite'];
  }

  toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['description'] = _description;
    map['date'] = _date;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['speaker'] = _speaker;
    return map;
  }
}
