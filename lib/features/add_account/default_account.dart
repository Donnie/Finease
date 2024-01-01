import 'package:finease/db/accounts.dart';

List<Account> defaultAccountsData() {
  return [
    Account(
      name: 'N26',
      balance: 0,
      currency: "EUR",
      liquid: true,
      self: true,
    ),
    Account(
      name: 'Groceries',
      balance: 0,
      currency: "EUR",
      liquid: false,
      self: false,
    ),
    Account(
      name: 'Friend',
      balance: 0,
      currency: "EUR",
      liquid: false,
      self: true,
    ),
  ];
}
