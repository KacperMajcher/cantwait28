class ItemModel {
  ItemModel(
      {required this.title,
      required this.imageURL,
      required this.releaseDate,
      required this.id});

  final String title;
  final String imageURL;
  final DateTime releaseDate;
  final String id;
}
