class FilterEvent {
  Map<String, dynamic> args;
  final int tab;
  final bool shouldRefresh;
  FilterEvent(this.args, {this.tab, this.shouldRefresh = true});
}
