/** A widget was displayed. */
class ShowWidgetEvent {
  // Identifier of the widget that was displayed, as resolved by the Rules Engine
  String? widgetId;

  // Name of the layer at which the widget was displayed
  String? layerName;

  ShowWidgetEvent(this.widgetId, this.layerName);
}
