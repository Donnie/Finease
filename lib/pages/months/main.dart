import 'package:finease/core/common.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';

class MonthsPage extends StatefulWidget {
  const MonthsPage({
    super.key,
  });

  @override
  State<MonthsPage> createState() => _MonthsPageState();
}

class _MonthsPageState extends State<MonthsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: const Scaffold(
        resizeToAvoidBottomInset: true,
        body: IndexedStack(
          children: [
            Center(
              child: Text("Months"),
            ),
          ],
        ),
      ),
    );
  }
}
