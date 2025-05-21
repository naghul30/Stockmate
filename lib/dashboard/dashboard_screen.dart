
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmate/dashboard/dashboard_controller.dart';
import 'package:stockmate/list/list_controller.dart';
import 'package:stockmate/list/list_screen.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    int totalItems = ref.watch(dashboardController).totalItems;
    int lowStockItems = ref.watch(dashboardController).lowStock;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {},
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DashboardCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'Total Items',
                        value: totalItems.toString(),
                        color: colorScheme.primaryContainer,
                        iconColor: colorScheme.primary,
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DashboardCard(
                        icon: Icons.warning_amber_outlined,
                        title: 'Low Stock',
                        value: lowStockItems.toString(),
                        color: colorScheme.errorContainer,
                        iconColor: colorScheme.error,
                        onTap: () async {
                          await ref.read(listController).getItems();
                          await ref.read(listController).filterLowStock();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
