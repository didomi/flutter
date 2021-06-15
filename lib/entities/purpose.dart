// Class used to represent a purpose.
class Purpose implements Comparable<Purpose> {
  // Purpose ID
  String? id;
  // IAB ID that the purpose should be mapped to (if the purpose is a custom purpose should be treated as an IAB purpose).
  String? iabId;
  // Name of the purpose.
  String? name;
  // Description of the purpose.
  String? description;
  // Legal description of the purpose.
  String? descriptionLegal;

  Purpose(this.id, this.iabId, this.name, this.description, this.descriptionLegal);

  Purpose.fromJson(dynamic json)
      : id = json["id"],
        iabId = json["iabId"],
        name = json["name"],
        description = json["description"],
        descriptionLegal = json["descriptionLegal"];

  @override
  int compareTo(Purpose other) => (id ?? "").compareTo(other.id ?? "");
}
