
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmate/add/add_controller.dart';
import 'package:stockmate/add/add_screen.dart';
import 'package:stockmate/list/list_controller.dart';

class EditPage extends ConsumerWidget {
  const EditPage({super.key});

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
              title: const Text('Edit Items',
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
                        await ref.read(listController).filter();
                      },
                      decoration: InputDecoration(
                        hintText: 'Search items to edit...',
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
                                  Icons.search_off_rounded,
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
                                    'Qty: $count  •  ₹$price per unit',
                                    style: textTheme.bodyMedium,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: colorScheme.primary,
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(addController)
                                              .nameController
                                              .text = name;
                                          ref
                                              .read(addController)
                                              .countController
                                              .text = count.toString();
                                          ref
                                              .read(addController)
                                              .priceController
                                              .text = price.toString();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddPage(isEdit: true),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: colorScheme.error,
                                        ),
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Confirm Deletion'),
                                              content: Text(
                                                  'Delete "$name" from inventory?'),
                                              icon: Icon(
                                                Icons.warning_amber_rounded,
                                                color: colorScheme.error,
                                                size: 48,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: Text('CANCEL'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: Text(
                                                    'DELETE',
                                                    style: TextStyle(
                                                        color:
                                                            colorScheme.error),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm ?? false) {
                                            await ref
                                                .read(listController)
                                                .deleteItem(name);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('"$name" deleted'),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
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
