import 'package:finease/db/accounts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.accounts,
  });

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ...accounts.map((ac) => AccountWidget(account: ac)),
        ],
      ),
    );
  }
}

class AccountWidget extends StatelessWidget {
  const AccountWidget({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat =
        DateFormat.yMd().add_Hms();

    return AspectRatio(
      aspectRatio: 16 / 6,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            // show transactions
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.name),
                const Divider(),
                Expanded(
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    children: [
                      infoTile(
                          'Balance', '${account.balance} ${account.currency}'),
                      infoTile('Liquid', account.liquid ? 'Yes' : 'No'),
                      infoTile('Debit', account.debit ? 'Yes' : 'No'),
                      infoTile('Track', account.track ? 'Yes' : 'No'),
                      infoTile(
                          'Created At', dateFormat.format(account.createdAt!)),
                      infoTile(
                          'Updated At', dateFormat.format(account.updatedAt!)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class ThisAccountTransactionWidget extends StatelessWidget {
  const ThisAccountTransactionWidget({
    super.key,
    required this.title,
    required this.content,
    required this.color,
  });

  final Color color;
  final String content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: context.titleLarge?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
