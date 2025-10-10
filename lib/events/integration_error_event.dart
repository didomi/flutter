/** Error while using an external SDK integration. */
class IntegrationErrorEvent {
  // External SDK integration name
  String integrationName;

  // Reason of the error
  String reason;

  IntegrationErrorEvent(this.integrationName, this.reason);
}
