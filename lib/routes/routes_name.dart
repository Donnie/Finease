enum RoutesName {
  accounts,
  addAccount,
  addEntry,
  addName,
  editAccount,
  home,
  intro,
  months,
  settings,
  setupAccounts,
  transactions,
  transactionsByDate,
  transactionsByAccount,
}

extension RoutesNameHelper on RoutesName {
  String get name => toString().split('.').last;
  String get path => '/$name';
  String get param => 'id';
  String get pathWparam => '$path/:$param';
}
