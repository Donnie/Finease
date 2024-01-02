import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/pages/setup_accounts/default_account.dart';
import 'package:finease/parts/account_item.dart';
import 'package:finease/parts/filled_card.dart';
import 'package:finease/parts/intro_top.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class IntroAccountAddWidget extends StatefulWidget {
  const IntroAccountAddWidget({
    super.key,
  });

  @override
  State<IntroAccountAddWidget> createState() => _IntroAccountAddWidgetState();
}

class _IntroAccountAddWidgetState extends State<IntroAccountAddWidget>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<List<Account>> accountsNotifier =
      ValueNotifier<List<Account>>([]);
  final AccountService _accountService = AccountService();

  @override
  bool get wantKeepAlive => true;
  List<Account> selectedAccounts = [];
  List<Account> egAccounts = defaultAccountsData();

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    final accounts =
        await _accountService.getAllAccounts();
    selectedAccounts = accounts;
    accountsNotifier.value = [...selectedAccounts];
  }

  void selectAccount(Account model) async {
    var account = await _accountService.createAccount(model);
    if (account != null) {
      setState(() {
        egAccounts.remove(model);
        selectedAccounts.add(account);
        accountsNotifier.value = [...selectedAccounts];
      });
    }
  }

  void deselectAccount(Account model) async {
    await _accountService.deleteAccount(model.id!);
    model.id = null;
    setState(() {
      egAccounts.add(model);
      selectedAccounts.remove(model);
      accountsNotifier.value = [...selectedAccounts];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          IntroTopWidget(
            titleWidget: Text(
              language["setupAccounts"],
              style: context.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.onSurface,
              ),
            ),
            icon: MdiIcons.bankPlus,
          ),
          ValueListenableBuilder<List<Account>>(
            valueListenable: accountsNotifier,
            builder: (context, accounts, child) {
              return ScreenTypeLayout.builder(
                mobile: (p0) => AppFilledCard(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: accounts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return AccountItemWidget(
                        account: account,
                        onPress: () => deselectAccount(account),
                      );
                    },
                  ),
                ),
                tablet: (p0) => FractionallySizedBox(
                  widthFactor: 0.8,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240,
                      childAspectRatio: 2,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: accounts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return AccountItemWidget(
                        account: account,
                        onPress: () => deselectAccount(account),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          FractionallySizedBox(
              widthFactor: 0.8,
              child: ListTile(
                title: Text(
                  language["recommendedAccounts"],
                  style: context.titleMedium,
                ),
              )),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                ...egAccounts.map(
                  (model) => FilterChip(
                    selected: false,
                    onSelected: (value) => selectAccount(model),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                      side: BorderSide(
                        width: 1,
                        color: context.primary,
                      ),
                    ),
                    showCheckmark: false,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(model.name),
                    labelStyle: context.titleMedium,
                    padding: const EdgeInsets.all(12),
                    avatar: Icon(
                      Icons.add_rounded,
                      color: context.primary,
                    ),
                  ),
                ),
                FilterChip(
                  selected: false,
                  onSelected: (value) {
                    print(value);
                    context.pushNamed(RoutesName.addAccount.name);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                      width: 1,
                      color: context.primary,
                    ),
                  ),
                  showCheckmark: false,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(language["addAccount"]),
                  labelStyle: context.titleMedium,
                  padding: const EdgeInsets.all(12),
                  avatar: Icon(
                    Icons.add_rounded,
                    color: context.primary,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    accountsNotifier.dispose();
    super.dispose();
  }
}
