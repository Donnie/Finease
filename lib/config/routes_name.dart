enum RoutesName {
  intro,
  addName,
}

extension RoutesNameHelper on RoutesName {
  String get name {
    switch (this) {
      case RoutesName.intro:
        return 'intro';
      case RoutesName.addName:
        return 'addName';
    }
  }

  String get path {
    switch (this) {
      case RoutesName.intro:
        return '/intro';
      case RoutesName.addName:
        return '/addName';
    }
  }
}
