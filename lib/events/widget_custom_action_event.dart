/** The user clicked a custom action button inside a widget. */
class WidgetCustomActionEvent {
  // Identifier of the widget, as resolved by the Rules Engine
  String widgetId;

  // Name of the layer where the custom action button was clicked
  String layerName;

  // Client-defined action identifier, passed through unchanged
  String customActionId;

  WidgetCustomActionEvent(this.widgetId, this.layerName, this.customActionId);
}
