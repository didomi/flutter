class SyncReadyEvent {
  // Boolean that indicates whether remote user status has been applied locally.
  bool statusApplied;
  // Function used to send a Sync Acknowledged API Event. Returns **true** if the API Event was sent, **false** otherwise.
  Future<bool> Function() syncAcknowledged = () async => false;

  SyncReadyEvent(this.statusApplied, this.syncAcknowledged);
}
