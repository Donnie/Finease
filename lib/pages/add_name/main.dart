import 'package:finease/config/routes_name.dart';
import 'package:finease/core/common.dart';
import 'package:finease/db/db.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/parts/intro_set_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddNamePage extends StatefulWidget {
  const AddNamePage({
    super.key,
    this.forceCountrySelector = false,
  });
  final bool forceCountrySelector;

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final SettingService _settingService = SettingService();

  @override
  void initState() {
    super.initState();
    getName();
  }

  void getName() async {
    final String userName = await SettingService().getSetting(Setting.userName);
    if (mounted) {
      setState(() {
        _nameController.text = userName;
      });
    }
  }

  void saveName() async {
    String name = _nameController.text;
    if (_formState.currentState!.validate()) {
      context.go(RoutesName.addAccount.path);
      await _settingService.setSetting(Setting.userName, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
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
                  onPressed: () {
                    saveName();
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
              child: IntroSetNameWidget(
                formState: _formState,
                nameController: _nameController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
