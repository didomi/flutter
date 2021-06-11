// String extension.
extension NewLineRemoving on String {
  // Extension method used to remove new lines characters.
  String removeNewLines() {
    var string = this;
    string = string.replaceAll("\n", "");
    string = string.replaceAll("\r", "");
    return string;
  }
}
