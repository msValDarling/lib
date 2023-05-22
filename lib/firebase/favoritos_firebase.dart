import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritosFirebase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference? _favoritosCollection;

  FavoritosFirebase() {
    _favoritosCollection = _firestore.collection('favoritos');
  }

  //Stream<QuerySnapshot> getAllFavoritos() {}
}
