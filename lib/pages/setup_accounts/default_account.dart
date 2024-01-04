import 'package:finease/db/accounts.dart';

List<Account> defaultAccountsData() {
  return [
    Account(
      name: 'N26',
      balance: 0,
      currency: "EUR",
      liquid: true,
      debit: true,
      owned: true,
    ),
    Account(
      name: 'Groceries',
      balance: 0,
      currency: "EUR",
      liquid: false,
      debit: false,
      owned: false,
    ),
    Account(
      name: 'Friend',
      balance: 0,
      currency: "EUR",
      liquid: false,
      debit: true,
      owned: true,
    ),
  ];
}
