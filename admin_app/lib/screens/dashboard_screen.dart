import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import 'users_screen.dart';
import 'shops_screen.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'logs_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false).loadDashboardData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          if (provider.stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = provider.stats!;

          return RefreshIndicator(
            onRefresh: () => provider.loadDashboardData(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatsGrid(stats),
                const SizedBox(height: 24),
                _buildQuickActions(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Users',
          stats['totalUsers'].toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          'Total Shops',
          stats['totalShops'].toString(),
          Icons.store,
          Colors.green,
        ),
        _buildStatCard(
          'Total Products',
          stats['totalProducts'].toString(),
          Icons.inventory,
          Colors.orange,
        ),
        _buildStatCard(
          'Total Orders',
          stats['totalOrders'].toString(),
          Icons.shopping_cart,
          Colors.purple,
        ),
        _buildStatCard(
          'Active Shops',
          stats['activeShops'].toString(),
          Icons.check_circle,
          Colors.teal,
        ),
        _buildStatCard(
          'Pending Orders',
          stats['pendingOrders'].toString(),
          Icons.pending,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          context,
          'Manage Users',
          Icons.people,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UsersScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'Manage Shops',
          Icons.store,
          Colors.green,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ShopsScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'Manage Products',
          Icons.inventory,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductsScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'Manage Orders',
          Icons.shopping_cart,
          Colors.purple,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrdersScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'System Logs',
          Icons.description,
          Colors.red,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LogsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
