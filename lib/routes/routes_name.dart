enum RoutesName {
  intro,
  addName,
  setupAccounts,
  home,
}

extension RoutesNameHelper on RoutesName {
  String get name {
    switch (this) {
      case RoutesName.intro:
        return 'intro';
      case RoutesName.addName:
        return 'addName';
      case RoutesName.setupAccounts:
        return 'setupAccounts';
      case RoutesName.home:
        return 'home';
    }
  }

  String get path {
    switch (this) {
      case RoutesName.intro:
        return '/intro';
      case RoutesName.addName:
        return '/addName';
      case RoutesName.setupAccounts:
        return '/setupAccounts';
      case RoutesName.home:
        return '/home';
    }
  }
}
