import 'package:cantwait212/models/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsRepository {
  Stream<List<ItemModel>> getItemsStream() {
    return FirebaseFirestore.instance
        .collection('items')
        .orderBy('release_date')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ItemModel(
            id: doc.id,
            title: doc['title'],
            imageURL: doc['image_url'],
            releaseDate: (doc['release_date'] as Timestamp).toDate());
      }).toList();
    });
  }

  Future<ItemModel> get({required String id}) async {
    final doc =
        await FirebaseFirestore.instance.collection('items').doc(id).get();
    return ItemModel(
        id: doc.id,
        title: doc['title'],
        imageURL: doc['image_url'],
        releaseDate: (doc['release_date'] as Timestamp).toDate());
  }

  Future<void> delete({required String id}) {
    return FirebaseFirestore.instance.collection('items').doc(id).delete();
  }

  Future<void> add(
    /*Jeżeli zostanie wywołana metoda add, która musi podać tytuł, link go grafiki i date 
     dodajemy te elemrnty odwołując się do firebasea*/
    final String title,
    final String imageURL,
    final DateTime releaseDate,
  ) async {
    {
      await FirebaseFirestore.instance.collection('items').add(
        {
          'title': title,
          'image_url': imageURL,
          'release_date': releaseDate,
        },
      );
    }
  }
}
