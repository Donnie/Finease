enum PageType {
  home,
  months,
  categories,
  overview,
  debts,
  budget,
  recurring;

  int get toIndex => index;
  String get name => toString().split('.').last;
}
