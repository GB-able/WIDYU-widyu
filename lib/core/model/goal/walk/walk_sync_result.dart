enum WalkSyncStatus { success, retry, unauthorized }

class WalkSyncResult {
  const WalkSyncResult(this.status, {this.achieved = false});
  final WalkSyncStatus status;
  final bool achieved;
}

class WalkSaveResult {
  const WalkSaveResult({
    this.date,
    this.steps,
    this.uploaded = 0,
    this.rewardChanged = false,
    this.unauthorized = false,
  });
  final String? date;
  final int? steps;
  final int uploaded;
  final bool rewardChanged;
  final bool unauthorized;
}
