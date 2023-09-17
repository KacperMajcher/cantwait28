import 'package:cantwait212/features/add/page/add_page.dart';
import 'package:cantwait212/features/details/pages/details_page.dart';
import 'package:cantwait212/features/home/cubit/home_cubit.dart';
import 'package:cantwait212/models/item_model.dart';
import 'package:cantwait212/repositories/item_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

/* Scaffold posiadający w sobie AppBAr z textem cant wait,
poniżej _HomePageBody i FloatingActionButton będący ikonką dodawania.
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Can't Wait 🤩"), // ("") bo jest apostrof w środku
      ),
      body:
          const _HomePageBody(), //podkreślnik sprawia, że do tego widoku nie mamy dostepu z żadnego innego pliku tzw. klasa prywatna
      floatingActionButton: FloatingActionButton(
        //ikona dodawania, wyświetla scaffold z AddPage
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPage(),
              fullscreenDialog:
                  true, //Ekran w lewym górnym rogu nie będzie miał opcji 'wstecz', tylko X do zamknięcia ekranu
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/* W _HomePageBody mamy BlocProvider z HomeCubit, który przy inicjalizacji
od razu wywołuje metode start, która z firebasea pobiera dane 
i emituje je w HomeState.
Do tego BlocBuilder obsługujacy nowy state gdy zostaje wrzucony.
Na początku jest to pusty HomeState nie posiadający żadnych danych,
boole z errorami są ustawione na false i pierwsze co robimy to sprawdzamy, 
czy dokumenty są nullem.
 builder: (context, state) {
          final docs = state.items?.docs;
          if (docs == null) {
            return const SizedBox.shrink();

Jeśli okaże się, że tak - zwracamy SizedBox.shrink, który jest pustym widgetem
*/

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(ItemsRepository())..start(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final itemModels = state.items;
          if (itemModels.isEmpty) {
            return const SizedBox.shrink();
          }
          return ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            children: [
              /*W children mamy pętle for in przelatującą przez wszystkie docs'y
              i dla każdego tworzy Dismissible widget, co pozwala przesuwaniem w bok
              usuwać pozycje z listy (a zarazem dokumenty z firebasea)
              Posiada on background z kolorem czerwonym i ikona kosza towarzyszaca przy usuwaniu pozycji

              confirmDismiss: (direction) async {
                    // only from right to left
                    return direction == DismissDirection.endToStart;
                  },
                  onDismissed: (direction) {
                    context.read<HomeCubit>().remove(documentID: doc.id);
                  
              Ta formuła mówi nam, że usuwanie dokumentu nastąpi dopiero po przesumięciu kafelka
              od strony prawej do lewej (endToStart), w innym wypadku confirmDismiss ustawia sie na false
              i nie dokonuje sie usuwanie
              */
              for (final itemModel in itemModels)
                Dismissible(
                  key: ValueKey(itemModel.id),
                  background: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 32.0),
                        child: Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    // only from right to left
                    return direction == DismissDirection.endToStart;
                  },
                  onDismissed: (direction) {
                    context.read<HomeCubit>().remove(documentID: itemModel.id);
                  },
                  child: _ListViewItem(
                    //wyświetla nam liste z dokumentami
                    itemModel: itemModel,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ListViewItem extends StatelessWidget {
  const _ListViewItem({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  final ItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsPage(id: itemModel.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  image: DecorationImage(
                    image: NetworkImage(
                      itemModel.imageURL,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            itemModel.title, //wyświetla nam tytuł
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            (itemModel.releaseDateFormatted()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //kontener zawierajacy ilosc dni
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          // '0', //poczatkowy hard code na 0
                          itemModel.daysLeft(),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('days left'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
