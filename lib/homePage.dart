import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmate/add/add_controller.dart';
import 'package:stockmate/add/add_screen.dart';
import 'package:stockmate/bill/bill_screen.dart';
import 'package:stockmate/dashboard/dashboard_controller.dart';
import 'package:stockmate/dashboard/dashboard_screen.dart';
import 'package:stockmate/edit/edit_screen.dart';
import 'package:stockmate/list/list_controller.dart';
import 'package:stockmate/list/list_screen.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {},
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: colorScheme.surface,
              title: const Text(
                'StockMate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withOpacity(0.9),
                  ],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MenuCard(
                          icon: Icons.analytics_outlined,
                          title: 'Dashboard',
                          color: colorScheme.primaryContainer,
                          onTap: () async {
                            await ref.read(dashboardController).valueUpdate();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _MenuCard(
                          icon: Icons.list_alt_outlined,
                          title: 'Item List',
                          color: colorScheme.secondaryContainer,
                          onTap: () async {
                            await ref.read(listController).getItems();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _MenuCard(
                          icon: Icons.add_circle_outline,
                          title: 'Add Item',
                          color: colorScheme.tertiaryContainer,
                          onTap: () async {
                            ref.read(addController).nameController.text = '';
                            ref.read(addController).countController.text = '';
                            ref.read(addController).priceController.text = '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _MenuCard(
                          icon: Icons.edit_outlined,
                          title: 'Edit Stock',
                          color: colorScheme.errorContainer,
                          onTap: () async {
                            await ref.read(listController).getItems();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _MenuCard(
                          icon: Icons.request_page,
                          title: 'Billing',
                          color: colorScheme.errorContainer,
                          onTap: () async {
                            await ref.read(listController).getItems();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BillPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
