/// Parameters used to display a widget
class DidomiWidgetParameters {
  /// Identifier of the widget to display.
  /// If not set, the widget is selected by the Rules Engine.
  String? widgetId;

  /// Name of the layer at which the widget should be displayed (e.g. `notice`, `purposes` or `vendors`).
  /// If not set, the widget is displayed at its default layer.
  String? layerName;

  DidomiWidgetParameters({this.widgetId, this.layerName});

  Map<String, dynamic> toJson() => {
        'widgetId': widgetId,
        'layerName': layerName,
      };
}
