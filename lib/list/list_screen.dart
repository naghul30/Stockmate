
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmate/list/list_controller.dart';

class ListPage extends ConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    TextEditingController searchController =
        ref.watch(listController).searchController;
    List<MapEntry<String, dynamic>> filteredEntries =
        ref.watch(listController).filteredEntries;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        searchController.clear();
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Item List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
              centerTitle: true,
              elevation: 0,
              actions: [
                
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onSelected: (value) async {
                    
                    switch (value) {
                      case 'name_asc':
                        await ref.read(listController).sortItems('name');
                        break;
                      case 'name_desc':
                        await ref
                            .read(listController)
                            .sortItems('name', ascending: false);
                        break;
                      case 'count_asc':
                        await ref.read(listController).sortItems('count');
                        break;
                      case 'count_desc':
                        await ref
                            .read(listController)
                            .sortItems('count', ascending: false);
                        break;
                      case 'price_asc':
                        await ref.read(listController).sortItems('price');
                        break;
                      case 'price_desc':
                        await ref
                            .read(listController)
                            .sortItems('price', ascending: false);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'name_asc',
                      child: Text('Sort by Name (A-Z)'),
                    ),
                    const PopupMenuItem(
                      value: 'name_desc',
                      child: Text('Sort by Name (Z-A)'),
                    ),
                    const PopupMenuItem(
                      value: 'count_asc',
                      child: Text('Sort by Quantity (Low-High)'),
                    ),
                    const PopupMenuItem(
                      value: 'count_desc',
                      child: Text('Sort by Quantity (High-Low)'),
                    ),
                    const PopupMenuItem(
                      value: 'price_asc',
                      child: Text('Sort by Price (Low-High)'),
                    ),
                    const PopupMenuItem(
                      value: 'price_desc',
                      child: Text('Sort by Price (High-Low)'),
                    ),
                  ],
                ),
              ],
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
                        await ref.read(listController).filter();
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
                                  ref.read(listController).filter();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (filteredEntries.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        backgroundColor: colorScheme.primaryContainer,
                        label: Text(
                          '${filteredEntries.length} items found',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: filteredEntries.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: colorScheme.onSurface.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No items found',
                                  style: textTheme.titleMedium?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: filteredEntries.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 72,
                              endIndent: 16,
                            ),
                            itemBuilder: (context, index) {
                              final entry = filteredEntries[index];
                              final name = entry.key;
                              final details = entry.value;
                              final price =
                                  int.tryParse(details['price'].toString()) ??
                                      0;
                              final count =
                                  int.tryParse(details['count'].toString()) ??
                                      0;

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
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
                                          color: colorScheme.onPrimaryContainer,
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
                                  subtitle: Text(
                                    'Quantity: $count',
                                    style: textTheme.bodyMedium,
                                  ),
                                  trailing: Text(
                                    '₹$price',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  onTap: () {},
                                ),
                              );
                            },
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
