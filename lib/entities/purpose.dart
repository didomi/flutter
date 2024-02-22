// Class used to represent a purpose.
class Purpose implements Comparable<Purpose> {
  // Purpose ID
  String? id;
  // Name of the purpose.
  String? name;
  // Description of the purpose.
  String? descriptionText;

  Purpose(this.id, this.name, this.descriptionText);

  Purpose.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        descriptionText = json["description"];

  @override
  int compareTo(Purpose other) => (id ?? "").compareTo(other.id ?? "");
}
