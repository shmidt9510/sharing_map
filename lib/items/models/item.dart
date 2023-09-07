class Item {
  final int? id;
  final String? name;
  final String? desc;
  final String? picture;
  final int? userId;
  final int? categoryId;
  final int? subcategoryId;
  final int? cityId;
  final DateTime? creationDate;
  // final String? author;

  // Item(this.id, this.name, this.desc, this.picture, this.creationDate);

  Item(
      {this.id,
      this.name,
      this.desc,
      this.picture,
      this.creationDate,
      this.categoryId,
      this.cityId,
      this.subcategoryId,
      this.userId});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        desc: json["text"],
        // picture: json["picture"],
        creationDate: json["creationDate"] == null
            ? null
            : DateTime.parse(json["creationDate"]),
        userId: json["user"]["id"],
        cityId: json["user"]["id"],
        categoryId: json["user"]["id"],
        subcategoryId: json["user"]["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "text": desc,
        "picture": picture,
        "user": {"id": userId},
        "city": {"id": cityId},
        "category": {"id": categoryId},
        "subcategory": {"id": subcategoryId},
        "adress": "asvasdvasdv"
      };
}

// {
//   "user": {"id": 1},
//   "category": {"id": 1},
//   "city": {"id": 0},
//   "subcategory": {"id": 1},
//   "name": "book",
//   "text": "hi12fsgfdhfjgzhfdgsdzhgxjfhhfgz!",
//   "address": "Moscow"
// }
final String picture = "assets/images/forest.jpg";
final List<Item> items = [
  Item(
      id: 0,
      name: "Item1",
      desc:
          "Generate descriptions of paintings, drawings, and the like. Use to create objects for stories and campaigns, or spark ideas for your own art.",
      picture: picture,
      creationDate: DateTime.parse("2002-02-27"),
      userId: 1,
      cityId: 1,
      categoryId: 1,
      subcategoryId: 1),
  Item(
      id: 1,
      name: "Item2",
      desc:
          "Create basic descriptions of books, though you get to figure out what the contents are. ;)",
      picture: picture,
      creationDate: DateTime.parse("2002-01-27")),
  Item(
      id: 2,
      name: "Item3",
      desc:
          "Stock a bakery window or figure out what your character's cake-baking auntie made with this generator.",
      picture: picture,
      creationDate: DateTime.parse("2022-02-27")),
  // Item(3, "Itme4", "Generate random sweet treats!", picture,
  //     DateTime.parse("2023-12-30")),
  // Item(4, "Itme4", "Generate random sweet treats!", picture,
  //     DateTime.parse("2023-12-30")),
  // Item(5, "Itme4", "Generate random sweet treats!", picture,
  //     DateTime.parse("2023-12-30")),
  // Item(6, "Itme4", "Generate random sweet treats!", picture,
  //     DateTime.parse("2023-12-30")),
  // Item(7, "Itme4", "Generate random sweet treats!", picture,
  //     DateTime.parse("2023-12-30")),
  // Item(8, "Itme4", "Generate random sweet treats!", picture,
  //     DateTime.parse("2023-12-30")),
];
