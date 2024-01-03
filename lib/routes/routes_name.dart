enum RoutesName {
  intro,
  addName,
  setupAccounts,
  addAccount,
  home,
  settings,
}

extension RoutesNameHelper on RoutesName {
  String get name => toString().split('.').last;
  String get path => '/$name';
}
