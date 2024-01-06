import 'package:finease/db/accounts.dart';

List<Account> defaultAccountsData(
  String prefCurrency,
) {
  return [
    Account(
      name: 'N26',
      balance: 0,
      currency: prefCurrency,
      liquid: true,
      type: AccountType.asset,
    ),
    Account(
      name: 'Groceries',
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      type: AccountType.expense,
    ),
    Account(
      name: 'Friend',
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      type: AccountType.asset,
    ),
  ];
}
