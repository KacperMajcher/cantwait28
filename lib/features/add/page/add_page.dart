import 'package:cantwait212/features/add/cubit/add_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

/* StatefulWidget posiadający 3 elementy
String? _imageURL;
String? _title;
DateTime? _releaseDate;
  */
class _AddPageState extends State<AddPage> {
  String? _imageURL;
  String? _title;
  DateTime? _releaseDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /*BlocProvider w ktorym inicjujemy AddCubit*/
      create: (context) => AddCubit(),
      child: BlocListener<AddCubit, AddState>(
        listener: (context, state) {
          if (state.saved) {
            Navigator.of(context).pop();
          }
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AddCubit, AddState>(
          /*BlocBuilder który wywołuje się za każdym razem gdy state AddCubit'a się zmieni */
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Add new upcoming title'),
                /*Nowy parametr dla AppBar'a - actions. Jest to lista widgetów dla actions
                    w którem możemy sobie dostarczać np IconButton,co jest ikonką z prawej
                    lub lewej strony AppBara (najczesciej check lub X)*/
                actions: [
                  IconButton(
                    /*Na onPressed w tym IconButton to weryfikacja; jesli choć jedna zmienna
                        jest równa null - na onPressed podajemy null, a addbutton jest nieaktywny,
                        inaczej dostarczamy całą funkcję i dodajemy dane do cubita*/
                    onPressed: _imageURL == null ||
                            _title == null ||
                            _releaseDate == null
                        ? null
                        : () {
                            context.read<AddCubit>().add(
                                  /*wykrzyknik oznacza, ze string na pewno nie przechowuje nulla*/
                                  _title!,
                                  _imageURL!,
                                  _releaseDate!,
                                );
                          },
                    icon: const Icon(
                        Icons.check), //ta ikonka wywołuje metodę add na cubicie
                  ),
                ],
              ),
              /*Tutaj posiadamy body przechowujacy prywatna klase _AddPageBody, któremu 
                  musimy dostarczyc az 4 elementy.
                  onTitleChanged
                  onImageUrlChanged
                  onDateChanged
                  selectedDateFormatted
                  */

              body: _AddPageBody(
                onTitleChanged: (newValue) {
                  //co jesli zmieni sie onTitle
                  setState(() {
                    _title =
                        newValue; //przypisz nową wartosc i wywolaj setState
                  });
                },
                onImageUrlChanged: (newValue) {
                  //co jesli zmieni sie onIamge
                  setState(() {
                    _imageURL =
                        newValue; //przypisz nową wartosc i wywolaj setState
                  });
                },
                onDateChanged: (newValue) {
                  //co jesl zmieni sie onDate
                  setState(() {
                    _releaseDate =
                        newValue; //przypisz nową wartosc i wywolaj setState
                  });
                },
                selectedDateFormatted: _releaseDate?.toIso8601String(),
                /*jaka jest aktualnie wybrana data - domyslnie null. 
                    Pytajnik mowi nam, ze jesli to null, nie probuj nawet tego konwertowac
                    jesli cos jest zamiast nulla, przekonwetuj to na stringa, 
                    przypisz nową wartosc i wywolaj setState*/
              ),
            );
          },
        ),
      ),
    );
  }
}

/*oddzielnie stworzony widget któremu dostarczamy wszystkie elementy */
class _AddPageBody extends StatelessWidget {
  const _AddPageBody({
    Key? key,
    required this.onTitleChanged,
    required this.onImageUrlChanged,
    required this.onDateChanged,
    this.selectedDateFormatted,
  }) : super(key: key);

  final Function(String) onTitleChanged;
  final Function(String) onImageUrlChanged;
  final Function(DateTime?) onDateChanged;
  final String? selectedDateFormatted;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      children: [
        TextField(
          onChanged: onTitleChanged,
          /*Możliwy również dłuższy zapis:
          onChanged: (newString){
            onTitleChanged(newString);
          }
           */
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            /*mamy title, a jak klikniemy to mamy jakas podpowiedz*/
            hintText: 'Matrix 5',
            label: Text('Title'),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: onImageUrlChanged,
          decoration: const InputDecoration(
            border:
                OutlineInputBorder(), //Textfield ma obramowanie z każdej strony
            /*mamy Image URL, a jak klikniemy to mamy jakas podpowiedz*/

            hintText: 'http:// ... .jpg',
            label: Text('Image URL'),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            /*Gdy klikniemy ten Elevated Button, wyświetla nam date picker
            dzieki async mozemy await'owac jakies futures, czyli np showDatepicker
            Jego działanie polega na czekaniu aż użytkownik wybierze jakas date
            nastepnie przekazuje ją do stałej selectedDate która wysyła dalej do firebasea
            initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              obie ustawione na dzisiejsza date, lastDae mozna ustawic na max 10 lat do przodu*/
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 365 * 10),
              ),
            );
            onDateChanged(selectedDate);
          },
          child: Text(selectedDateFormatted ?? 'Choose release date'),
        ),
      ],
    );
  }
}
