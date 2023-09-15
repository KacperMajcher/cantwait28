import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantwait212/models/item_model.dart';
import 'package:cantwait212/repositories/item_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._itemRepository) : super(const HomeState());

  final ItemsRepository _itemRepository;
  StreamSubscription? _streamSubscription;

  Future<void> start() async {
    _streamSubscription = _itemRepository.getItemsStream().listen(
      (items) {
        final itemModels = items;
        emit(HomeState(items: itemModels));
      },
    )..onError(
        (error) {
          emit(const HomeState(
              loadingErrorOccured:
                  true)); //Jeżeli ładowanie zostało przerwane emituje state z errorem
        },
      );
  }

/* remove odnoszacy sie do formuły dismissed z _HomePageBody,
tutaj działa w firebase, tam we flutterze */

  Future<void> remove({required String documentID}) async {
    try {
      await _itemRepository.delete(id: documentID);
    } catch (error) {
      emit(
        const HomeState(
            removingErrorOccured:
                true), //jesli wystapi błąd, emitujemy statea który nas o tym informuje i emitujemy start()
      );
      start();
    }
  }

/*close zamykajacy stream jeżeli użytkownik wychodzi z aplikacji 
zeby appka nie jadła RAMu niepotrzebnie*/

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
