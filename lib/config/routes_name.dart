enum RoutesName {
  intro,
  addName,
  addAccount,
  home,
}

extension RoutesNameHelper on RoutesName {
  String get name {
    switch (this) {
      case RoutesName.intro:
        return 'intro';
      case RoutesName.addName:
        return 'addName';
      case RoutesName.addAccount:
        return 'addAccount';
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
      case RoutesName.addAccount:
        return '/addAccount';
      case RoutesName.home:
        return '/home';
    }
  }
}
