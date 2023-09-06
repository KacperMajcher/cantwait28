import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  StreamSubscription? _streamSubscription;

  Future<void> start() async {
    _streamSubscription = FirebaseFirestore.instance
        .collection('items')
        .orderBy('release_date')
        .snapshots()
        .listen(
      (items) {
        emit(HomeState(
            items:
                items)); //gdy przychodza do nas jakies nowe dane z firebasea, od razu przychodzą
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
      await FirebaseFirestore.instance
          .collection('items')
          .doc(documentID)
          .delete();
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
