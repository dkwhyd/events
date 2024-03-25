import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/even_detail.dart';
import 'package:events/models/favorite.dart';

class FireStoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  // add favorite
  static Future addFavorite(EventDetail eventDetail, String uid) {
    Favorite fav = Favorite(null, eventDetail.id, uid);
    var result = db
        .collection('favorites')
        .add(fav.toMap())
        .catchError((error) => error);
    return result;
  }

  // delete favorite
  static Future deleteFavorite(String favId) async {
    var result = await db.collection('favorites').doc(favId).delete();
    return result;
  }

  static Future<List<Favorite>> getUserFavorite(String uid) async {
    List<Favorite> favs = [];
    QuerySnapshot docs =
        await db.collection('favorites').where('userId', isEqualTo: uid).get();
    for (var doc in docs.docs) {
      Favorite favorite = Favorite.map(doc); // Buat objek Favorite dari dokumen
      favorite.id = doc.id; // Setel ID snapshot ke objek Favorite
      favs.add(favorite); // Tambahkan objek Favorite ke daftar favorit
    }
    return favs;
  }
}
