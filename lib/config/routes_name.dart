enum RoutesName {
  intro,
  onboarding,
}

extension RoutesNameHelper on RoutesName {
  String get name {
    switch (this) {
      case RoutesName.intro:
        return 'intro';
      case RoutesName.onboarding:
        return 'onboarding';
    }
  }

  String get path {
    switch (this) {
      case RoutesName.intro:
        return '/intro';
      case RoutesName.onboarding:
        return '/onboarding';
    }
  }
}
