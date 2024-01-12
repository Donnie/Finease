import 'package:finease/pages/home/summary/net_worth_card.dart';
import 'package:finease/parts/variable_fab_size.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SummaryMobileWidget extends StatelessWidget {
  const SummaryMobileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 1,
        padding: const EdgeInsets.only(bottom: 124),
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: NetWorthCard(),
          );
        },
      ),
      floatingActionButton: VariableFABSize(
        onPressed: () async {
          await context.pushNamed(
            RoutesName.addEntry.name,
            extra: () => {},
          );
        },
        icon: Icons.add,
      ),
    );
  }
}
