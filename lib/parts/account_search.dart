import 'package:finease/db/accounts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountSearchDelegate extends SearchDelegate<Account?> {
  List<Account> accounts;
  Account? selected;
  bool once = false;
  AccountSearchDelegate({required this.accounts, this.selected});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          selected = null;
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, selected),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (!once && selected != null && selected!.name.isNotEmpty) {
      query = selected?.name ?? '';
      once = true;
    }

    List<Account> filteredList = accounts.where((account) {
      return account.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Unlink',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            onTap: context.pop,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredList[index].name),
                onTap: () {
                  close(context, filteredList[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
