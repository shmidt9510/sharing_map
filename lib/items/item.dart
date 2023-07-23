class Item {
  final int id;
  final String name;
  final String desc;
  final String picture;
  Item(this.id, this.name, this.desc, this.picture);
}

final String picture = "assets/images/forest.jpg";
final List<Item> items = [
  Item(
      0,
      "Item1",
      "Generate descriptions of paintings, drawings, and the like. Use to create objects for stories and campaigns, or spark ideas for your own art.",
      picture),
  Item(
      1,
      "Item2",
      "Create basic descriptions of books, though you get to figure out what the contents are. ;)",
      picture),
  Item(
      2,
      "Item3",
      "Stock a bakery window or figure out what your character's cake-baking auntie made with this generator.",
      picture),
  Item(3, "Itme4", "Generate random sweet treats!", picture),
  Item(4, "Itme4", "Generate random sweet treats!", picture),
  Item(5, "Itme4", "Generate random sweet treats!", picture),
  Item(6, "Itme4", "Generate random sweet treats!", picture),
  Item(7, "Itme4", "Generate random sweet treats!", picture),
  Item(8, "Itme4", "Generate random sweet treats!", picture),
];
