/** The user navigated to another layer inside a widget. */
class WidgetSwitchLayerEvent {
  // Identifier of the widget, as resolved by the Rules Engine
  String? widgetId;

  // Name of the layer the user navigated from
  String? layerName;

  // Name of the layer the user navigated to
  String? targetLayerName;

  WidgetSwitchLayerEvent(this.widgetId, this.layerName, this.targetLayerName);
}
