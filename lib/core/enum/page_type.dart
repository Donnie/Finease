import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

enum PageType {
  home,
  accounts,
  category,
  overview,
  debts,
  budget,
  recurring;

  int get toIndex {
    switch (this) {
      case PageType.home:
        return 0;
      case PageType.accounts:
        return 1;
      case PageType.category:
        return 2;
      case PageType.overview:
        return 3;
      case PageType.debts:
        return 4;
      case PageType.budget:
        return 5;
      case PageType.recurring:
        return 6;
    }
  }

  String name(BuildContext context) {
    switch (this) {
      case PageType.home:
        return language["home"];
      case PageType.accounts:
        return language["accounts"];
      case PageType.overview:
        return language["overview"];
      case PageType.category:
        return language["categories"];
      case PageType.debts:
        return language["debts"];
      case PageType.budget:
        return language["budget"];
      case PageType.recurring:
        return language["recurring"];
    }
  }

  String toolTip(BuildContext context) {
    switch (this) {
      case PageType.home:
        return language["addTransactionTooltip"];
      case PageType.accounts:
        return language["addAccountTooltip"];
      case PageType.overview:
        return language["selectDateRangeTooltip"];
      case PageType.category:
        return language["addCategoryTooltip"];
      case PageType.debts:
        return language["addDebtTooltip"];
      case PageType.recurring:
        return language["recurring"];
      case PageType.budget: // Doesn't have FAB button
        return '';
    }
  }
}
