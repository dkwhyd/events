import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/even_detail.dart';
import 'package:events/models/favorite.dart';

class FireStoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future addFavorite(EventDetail eventDetail, String uid) {
    Favorite fav = Favorite(null, uid, uid);
    var result = db
        .collection('favorite')
        .add(fav.toMap())
        .then((value) => print(value))
      .catchError((error) => print(error));

    return result;
  }
}
