enum RoutesName {
  intro,
  addName,
  entries,
  accounts,
  setupAccounts,
  addAccount,
  editAccount,
  addEntry,
  home,
  settings,
}

extension RoutesNameHelper on RoutesName {
  String get name => toString().split('.').last;
  String get path => '/$name';
  String get param => 'id';
  String get pathWparam => '$path/:$param';
}
