import 'package:finease/db/accounts.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:finease/core/export.dart';
import 'package:finease/db/db.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/pages/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddInfoPage extends StatefulWidget {
  const AddInfoPage({
    super.key,
  });

  @override
  State<AddInfoPage> createState() => _AddInfoPageState();
}

class _AddInfoPageState extends State<AddInfoPage> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _currency = TextEditingController();
  final SettingService _settingService = SettingService();
  final AccountService _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() async {
    final String userName = await _settingService.getSetting(Setting.userName);
    final String currency =
        await _settingService.getSetting(Setting.prefCurrency);
    if (mounted) {
      setState(() {
        _name.text = userName;
        _currency.text = currency;
      });
    }
  }

  void saveForm() async {
    if (_formState.currentState!.validate()) {
      context.go(RoutesName.setupAccounts.path);
      await _settingService.setSetting(Setting.userName, _name.text);

      Account account = await _accountService.createAccount(Account(
        balance: 0,
        currency: _currency.text,
        liquid: false,
        name: "Past",
        hidden: true,
        type: AccountType.income,
      ));
      await _settingService.setSetting(Setting.pastAccount, "${account.id}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              FloatingActionButton.extended(
                heroTag: 'backButton',
                onPressed: () {
                  context.go(RoutesName.intro.path);
                  DatabaseHelper().clearDatabase();
                },
                extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
                label: Text(
                  language["back"],
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                icon: Icon(MdiIcons.arrowLeft),
              ),
              const Spacer(),
              FloatingActionButton.extended(
                heroTag: 'next',
                onPressed: () async {
                  // to avoid race condition with next page
                  // next page needs the currency
                  await _settingService.setSetting(
                      Setting.prefCurrency, _currency.text);

                  saveForm();
                },
                extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
                label: Icon(MdiIcons.arrowRight),
                icon: Text(
                  language["next"],
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        children: [
          Center(
            child: AddInfoBody(
              formState: _formState,
              name: _name,
              currency: _currency,
            ),
          ),
        ],
      ),
    );
  }
}
