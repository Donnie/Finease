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
      debit: true,
      track: true,
    ),
    Account(
      name: 'Groceries',
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      debit: false,
      track: false,
    ),
    Account(
      name: 'Friend',
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      debit: true,
      track: true,
    ),
  ];
}
