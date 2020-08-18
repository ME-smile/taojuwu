class SortEvent {
  String text;
  bool isChecked;
  String order;
  String sort;
  SortEvent({this.text, this.isChecked, this.order, this.sort});

  SortEvent.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    isChecked = json['is_checked'];
    order = json['order'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    return {'order': order, 'sort': sort};
  }
}
