/// Privacy Widget that collected the current consent.
///
/// **Beta**: this API is in beta and may change in future releases.
class SourceWidget {
  // Widget type, if defined in the widget catalog.
  String? type;
  // Widget ID.
  String id;
  // Widget version ID, if defined in the widget catalog.
  String? versionId;

  SourceWidget(this.type, this.id, this.versionId);

  SourceWidget.fromJson(dynamic json)
      : type = json["type"],
        id = json["id"],
        versionId = json["version_id"];
}
