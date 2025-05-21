
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmate/add/add_controller.dart';

class AddPage extends ConsumerWidget {
  final bool isEdit;
  const AddPage({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    TextEditingController nameController =
        ref.watch(addController).nameController;
    String oldName =   ref.watch(addController).nameController.text;
    TextEditingController countController =
        ref.watch(addController).countController;
    TextEditingController priceController =
        ref.watch(addController).priceController;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {},
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(isEdit ? 'Edit Item' : 'Add Item',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _InputCard(
                    child: TextField(
                      controller: nameController,
                      style: textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: "Item Name",
                        labelStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.inventory_2_outlined,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InputCard(
                    child: TextField(
                      controller: countController,
                      keyboardType: TextInputType.number,
                      style: textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: "Quantity",
                        labelStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.numbers_outlined,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InputCard(
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      style: textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: "Price per Unit",
                        labelStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.currency_rupee_outlined,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(addController)
                            .addItem(context, isEdit, ref, oldName);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: colorScheme.primary,
                        elevation: 2,
                      ),
                      child: Text(
                        isEdit ? 'UPDATE ITEM' : 'ADD ITEM',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (nameController.text.isNotEmpty ||
                      countController.text.isNotEmpty ||
                      priceController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preview',
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nameController.text.isEmpty
                                      ? 'Item Name'
                                      : nameController.text,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Qty: ${countController.text.isEmpty ? '0' : countController.text}',
                                      style: textTheme.bodyMedium,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Price: ₹${priceController.text.isEmpty ? '0' : priceController.text}',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                if (countController.text.isNotEmpty &&
                                    priceController.text.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Total: ₹${(int.tryParse(countController.text) ?? 0) * (int.tryParse(priceController.text) ?? 0)}',
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
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

class _InputCard extends StatelessWidget {
  final Widget child;

  const _InputCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 208, 189, 243)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: child,
      ),
    );
  }
}
