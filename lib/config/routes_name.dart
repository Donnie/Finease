enum RoutesName {
  intro,
  userOnboarding,
}

extension RoutesNameHelper on RoutesName {
  String get name {
    switch (this) {
      case RoutesName.intro:
        return 'intro';
      case RoutesName.userOnboarding:
        return 'onboarding';
    }
  }

  String get path {
    switch (this) {
      case RoutesName.intro:
        return '/intro';
      case RoutesName.userOnboarding:
        return '/onboarding';
    }
  }
}
