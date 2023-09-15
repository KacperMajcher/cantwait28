import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'add_state.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit() : super(const AddState());

  Future<void> add(
    /*Jeżeli zostanie wywołana metoda add, która musi podać tytuł, link go grafiki i date 
     dodajemy te elemrnty odwołując się do firebasea*/
    final String title,
    final String imageURL,
    final DateTime releaseDate,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('items').add(
        {
          'title': title,
          'image_url': imageURL,
          'release_date': releaseDate,
        },
      );
      emit(const AddState(
          saved: true)); //emitujemy stste, ze zapisanie się powiodło
    } catch (error) {
      emit(AddState(
          errorMessage: error
              .toString())); //jeśli w tym awaicie wystąpiłby jakiś błąd, try catch od razu przechodzi do catch i emituje state o błędzie
    }
  }
}
