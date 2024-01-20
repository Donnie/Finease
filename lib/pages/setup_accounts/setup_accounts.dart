import 'package:finease/core/export.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/parts/account_item.dart';
import 'package:finease/parts/filled_card.dart';
import 'package:finease/parts/intro_top.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SetupAccountsWidget extends StatefulWidget {
  const SetupAccountsWidget({super.key});

  @override
  SetupAccountsWidgetState createState() => SetupAccountsWidgetState();
}

class SetupAccountsWidgetState extends State<SetupAccountsWidget>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<List<Account>> accountsNotifier =
      ValueNotifier<List<Account>>([]);
  final AccountService _accountService = AccountService();
  final SettingService _settingService = SettingService();

  @override
  bool get wantKeepAlive => true;

  List<Account> selectedAccounts = [];
  List<Account> egAccounts = [];

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
    _setEgAccount();
  }

  Future<void> _fetchAccounts() async {
    final accounts = await _accountService.getAllAccounts(false);
    setState(() {
      selectedAccounts = accounts;
      accountsNotifier.value = [...selectedAccounts];
    });
  }

  Future<void> _setEgAccount() async {
    final prefCurrency = await _settingService.getSetting(Setting.prefCurrency);
    setState(() {
      egAccounts = defaultAccountsData(prefCurrency);
    });
  }

  void selectAccount(Account model) async {
    var account = await _accountService.createAccount(model);
    setState(() {
      egAccounts.remove(model);
      selectedAccounts.add(account);
      accountsNotifier.value = [...selectedAccounts];
    });
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
                mobile: (context) => _buildAccountListView(accounts),
                tablet: (context) => _buildAccountGridView(accounts),
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
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                ...egAccounts.map(
                    (model) => _buildAccountChip(model, isEGAccount: true)),
                AddNewAccount(
                  onSelected: (val) => context.pushNamed(
                    RoutesName.addAccount.name,
                    extra: (Account account) => _fetchAccounts(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountListView(List<Account> accounts) {
    return AppFilledCard(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: accounts.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => AccountItemWidget(
          account: (accounts[index]),
          onPress: () => deselectAccount((accounts[index])),
        ),
      ),
    );
  }

  Widget _buildAccountGridView(List<Account> accounts) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          childAspectRatio: 2,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: accounts.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => AccountItemWidget(
          account: (accounts[index]),
          onPress: () => deselectAccount((accounts[index])),
        ),
      ),
    );
  }

  Widget _buildAccountChip(Account model, {required bool isEGAccount}) {
    return AccountChip(
      avatar: Icon(
        Icons.add_rounded,
        color: context.primary,
      ),
      label: Text(model.name),
      onSelected: (val) =>
          isEGAccount ? selectAccount(model) : deselectAccount(model),
    );
  }
}
