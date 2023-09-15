import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantwait212/repositories/item_repository.dart';

part 'add_state.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit(this._itemRepository) : super(const AddState());

  final ItemsRepository _itemRepository;

  Future<void> add(
    /*Jeżeli zostanie wywołana metoda add, która musi podać tytuł, link go grafiki i date 
     dodajemy te elemrnty odwołując się do firebasea*/
    final String title,
    final String imageURL,
    final DateTime releaseDate,
  ) async {
    try {
      await _itemRepository.add(title, imageURL, releaseDate);
      emit(const AddState(
          saved: true)); //emitujemy stste, ze zapisanie się powiodło
    } catch (error) {
      emit(AddState(
          errorMessage: error
              .toString())); //jeśli w tym awaicie wystąpiłby jakiś błąd, try catch od razu przechodzi do catch i emituje state o błędzie
    }
  }
}
