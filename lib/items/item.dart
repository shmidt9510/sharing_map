class Item {
  final int id;
  final String name;
  final String desc;
  final String picture;
  final DateTime creationDate;
  Item(this.id, this.name, this.desc, this.picture, this.creationDate);
}

final String picture = "assets/images/forest.jpg";
final List<Item> items = [
  Item(
      0,
      "Item1",
      "Generate descriptions of paintings, drawings, and the like. Use to create objects for stories and campaigns, or spark ideas for your own art.",
      picture,
      DateTime.parse("2002-02-27")),
  Item(
      1,
      "Item2",
      "Create basic descriptions of books, though you get to figure out what the contents are. ;)",
      picture,
      DateTime.parse("2002-01-27")),
  Item(
      2,
      "Item3",
      "Stock a bakery window or figure out what your character's cake-baking auntie made with this generator.",
      picture,
      DateTime.parse("2022-02-27")),
  Item(3, "Itme4", "Generate random sweet treats!", picture,
      DateTime.parse("2023-12-30")),
  Item(4, "Itme4", "Generate random sweet treats!", picture,
      DateTime.parse("2023-12-30")),
  Item(5, "Itme4", "Generate random sweet treats!", picture,
      DateTime.parse("2023-12-30")),
  Item(6, "Itme4", "Generate random sweet treats!", picture,
      DateTime.parse("2023-12-30")),
  Item(7, "Itme4", "Generate random sweet treats!", picture,
      DateTime.parse("2023-12-30")),
  Item(8, "Itme4", "Generate random sweet treats!", picture,
      DateTime.parse("2023-12-30")),
];
