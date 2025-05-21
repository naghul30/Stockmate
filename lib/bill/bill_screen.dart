import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmate/bill/bill_controller.dart';
import 'package:stockmate/list/list_controller.dart';

class BillPage extends ConsumerWidget {
  const BillPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    TextEditingController searchController =
        ref.watch(listController).searchController;
    List<MapEntry<String, dynamic>> filteredEntries =
        ref.watch(listController).filteredEntries;
    List<MapEntry<String, dynamic>> billList =
        ref.watch(billController).billList;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        ref.read(billController).notCheckout();
        searchController.clear();
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Billing',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) async {
                        ref.read(listController).filter(true);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search items...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  ref.read(listController).filter(true);
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Column(
                      children: [
                        if (searchController.text.isNotEmpty)
                          Expanded(
                            child: filteredEntries.isEmpty
                                ? Center(
                                    child: Text(
                                    'No items found',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                  ))
                                : ListView.separated(
                                    itemCount: filteredEntries.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      height: 1,
                                      thickness: 1,
                                      indent: 72,
                                      endIndent: 16,
                                    ),
                                    itemBuilder: (context, index) {
                                      final entry = filteredEntries[index];
                                      final name = entry.key;
                                      final details = entry.value;
                                      final price = int.tryParse(
                                              details['price'].toString()) ??
                                          0;
                                      final count = int.tryParse(
                                              details['count'].toString()) ??
                                          0;

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surface,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color:
                                                  colorScheme.primaryContainer,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            name,
                                            style:
                                                textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text('Price: ₹$price',
                                                  style: textTheme.bodyMedium)
                                            ],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                          onTap: () {
                                            ref
                                                .read(billController)
                                                .billListAppender(name, ref);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Text(
                              'YOUR BILL',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 66, 1, 139),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            )
                          ],
                        ),
                        if (billList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text('Search and add items...',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                )),
                          ),
                        if (billList.isNotEmpty)
                          Expanded(
                            child: ListView.separated(
                              itemCount: billList.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 72,
                                endIndent: 16,
                              ),
                              itemBuilder: (context, index) {
                                final entry = billList[index];
                                final name = entry.key;
                                final details = entry.value;
                                final price =
                                    int.tryParse(details['price'].toString()) ??
                                        0;
                                final count = int.tryParse(
                                        details['countt'].toString()) ??
                                    0;

                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: textTheme.bodyMedium?.copyWith(
                                            color:
                                                colorScheme.onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      name,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text('Price: ₹$price',
                                            style: textTheme.bodyMedium)
                                      ],
                                    ),
                                    trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove,
                                            ),
                                            color: colorScheme.primary,
                                            onPressed: () async {
                                              await ref
                                                  .read(billController)
                                                  .billListAppender(
                                                      name, ref, true);
                                            },
                                          ),
                                          Text('$count',
                                              style: textTheme.bodyMedium),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add,
                                            ),
                                            color: colorScheme.primary,
                                            onPressed: () async {
                                              await ref
                                                  .read(billController)
                                                  .billListAppender(name, ref);
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                          Text('₹${price * count}',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ]),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    onTap: () {},
                                  ),
                                );
                              },
                            ),
                          ),
                        if (billList.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              border: Border.all(
                                color: const Color.fromARGB(255, 112, 2, 160),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Grand Total',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${billList.fold<int>(0, (sum, item) {
                                        final price = int.tryParse(item
                                                .value['price']
                                                .toString()) ??
                                            0;
                                        final count = int.tryParse(item
                                                .value['countt']
                                                .toString()) ??
                                            0;
                                        return sum + (price * count);
                                      })}',
                                      style: textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ref.read(billController).checkout(context);
                                  },
                                  icon: const Icon(
                                    Icons.receipt_long,
                                    color: Colors.white,
                                  ),
                                  label: const Text("Checkout"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
