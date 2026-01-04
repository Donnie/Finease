import 'package:finease/core/extensions/color_extension.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/currency.dart';
import 'package:finease/db/entries.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EntriesListView extends StatelessWidget {
  final List<Entry> entries;
  final Function(int)? onDelete;
  final Function() onEdit;

  const EntriesListView({
    super.key,
    required this.entries,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return EntryCard(
          entry: entries[index],
          onDelete: onDelete,
          onCardTap: onEdit,
        );
      },
    );
  }
}

class EntryCard extends StatelessWidget {
  final Entry entry;
  final Function(int)? onDelete;
  final Function()? onCardTap;

  const EntryCard({
    super.key,
    required this.entry,
    required this.onCardTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String symbol = SupportedCurrency[entry.debitAccount!.currency]!;
    final cardColor = entry.creditAccount?.type == AccountType.expense ? context.secondaryContainer : context.tertiaryContainer;

    return InkWell(
      onTap: () async {
        final result = await context.pushNamed(
          RoutesName.editEntry.name,
          pathParameters: {'id': entry.id.toString()},
        );
        if (result == true && onCardTap != null) {
          onCardTap!();
        }
      },
      onLongPress: () async {
        final result = await context.pushNamed(
          RoutesName.duplicateEntry.name,
          pathParameters: {'id': entry.id.toString()},
        );
        if (result == true && onCardTap != null) {
          onCardTap!();
        }
      },
    child: Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('From: ${entry.debitAccount!.name}'),
                Text(getFormattedDate(entry.date!)),
                Text('To: ${entry.creditAccount!.name}'),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$symbol ${entry.amount}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      entry.notes!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    final bool confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text(
                            'Once you delete a transaction the balance '
                            'in related accounts would be automatically '
                            'readjusted',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm) {
                      onDelete?.call(entry.id!);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    child: Icon(MdiIcons.delete),
                  ),
                )
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

String getFormattedDate(DateTime entryDate) {
  final now = DateTime.now();
  final difference = now.difference(entryDate);

  if (difference.inDays < 1) {
    // Less than a day
    if (difference.inHours < 1) {
      // Less than a day
      return 'moments ago';
    }
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 2) {
    // Less than a week
    return 'yesterday';
  } else {
    // More than a week - show absolute time
    return DateFormat('yyyy-MM-dd HH:mm').format(entryDate);
  }
}
