enum RoutesName {
  accountAddTransaction,
  accountEditTransaction,
  accountTransactions,
  accountTransactionsEditAccount,
  addAccount,
  addCategory,
  addDebtCredit,
  addRecurring,
  addTransaction,
  appFontChanger,
  appLanguageChanger,
  biometric,
  editAccount,
  editCategory,
  editDebitCredit,
  editTransaction,
  exportAndImport,
  iconPicker,
  intro,
  landing,
  login,
  search,
  settings,
  transactionsByCategory,
  userOnboarding,
}

extension RoutesNameHelper on RoutesName {
  String get name {
    switch (this) {
      case RoutesName.accountAddTransaction:
        return 'account-add-transaction';
      case RoutesName.accountEditTransaction:
        return 'account-edit-transaction';
      case RoutesName.accountTransactions:
        return 'account-transactions';
      case RoutesName.accountTransactionsEditAccount:
        return 'account-transaction-edit-account';
      case RoutesName.addAccount:
        return 'add-account';
      case RoutesName.addCategory:
        return 'add-category';
      case RoutesName.addDebtCredit:
        return 'add-debit-credit';
      case RoutesName.addRecurring:
        return 'add-recurring';
      case RoutesName.addTransaction:
        return 'add-transaction';
      case RoutesName.appFontChanger:
        return 'font-picker';
      case RoutesName.appLanguageChanger:
        return 'app-language';
      case RoutesName.biometric:
        return 'biometric';
      case RoutesName.editAccount:
        return 'edit-account';
      case RoutesName.editCategory:
        return 'edit-category';
      case RoutesName.editDebitCredit:
        return 'edit-debit-credit';
      case RoutesName.editTransaction:
        return 'edit-transaction';
      case RoutesName.exportAndImport:
        return 'import-export';
      case RoutesName.iconPicker:
        return 'icon-picker';
      case RoutesName.intro:
        return 'intro';
      case RoutesName.landing:
        return 'landing';
      case RoutesName.login:
        return 'login';
      case RoutesName.search:
        return 'search';
      case RoutesName.settings:
        return 'settings';
      case RoutesName.transactionsByCategory:
        return 'transactions';
      case RoutesName.userOnboarding:
        return 'onboarding';
    }
  }

  String get path {
    switch (this) {
      case RoutesName.accountAddTransaction:
        return 'add-transaction';
      case RoutesName.accountEditTransaction:
        return 'edit-transaction/:eid';
      case RoutesName.accountTransactions:
        return 'account-transactions/:aid';
      case RoutesName.accountTransactionsEditAccount:
        return 'edit-account';
      case RoutesName.addAccount:
        return 'add-account';
      case RoutesName.addCategory:
        return 'add-category';
      case RoutesName.addDebtCredit:
        return 'add-debit-credit';
      case RoutesName.addRecurring:
        return 'add-recurring';
      case RoutesName.addTransaction:
        return 'add-transaction';
      case RoutesName.appFontChanger:
        return 'font-picker';
      case RoutesName.appLanguageChanger:
        return 'app-language';
      case RoutesName.biometric:
        return '/biometric';
      case RoutesName.editAccount:
        return 'edit-account/:aid';
      case RoutesName.editCategory:
        return 'edit-category/:cid';
      case RoutesName.editDebitCredit:
        return 'edit-debit-credit';
      case RoutesName.editTransaction:
        return 'edit-transaction/:eid';
      case RoutesName.exportAndImport:
        return 'import-export';
      case RoutesName.iconPicker:
        return 'icon-picker';
      case RoutesName.intro:
        return '/intro';
      case RoutesName.landing:
        return '/landing';
      case RoutesName.login:
        return '/login';
      case RoutesName.search:
        return 'search';
      case RoutesName.settings:
        return 'settings';
      case RoutesName.transactionsByCategory:
        return 'transactions/:cid';
      case RoutesName.userOnboarding:
        return '/onboarding';
    }
  }
}
