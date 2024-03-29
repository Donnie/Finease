import 'package:finease/db/accounts.dart';

const String capitalGains = 'Capital Gains';
List<Account> defaultAccountsData(
  String prefCurrency,
) {
  return [
    Account(
      name: 'Job',
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      type: AccountType.income,
    ),
    Account(
      name: capitalGains,
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      type: AccountType.income,
    ),
    Account(
      name: 'Groceries',
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      type: AccountType.expense,
    ),
    Account(
      name: 'Travel',
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      type: AccountType.expense,
    ),
    Account(
      name: 'Rent',
      balance: 0,
      currency: prefCurrency,
      liquid: false,
      type: AccountType.expense,
    ),
  ];
}
