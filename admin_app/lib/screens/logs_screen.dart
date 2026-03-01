import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false).loadLogs();
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          if (provider.logs == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = provider.logs!;

          return RefreshIndicator(
            onRefresh: () => provider.loadLogs(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  'Recent Users',
                  Icons.people,
                  Colors.blue,
                  logs['recentUsers'] as List? ?? [],
                  (item) => _buildUserLog(item),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  'Recent Shops',
                  Icons.store,
                  Colors.green,
                  logs['recentShops'] as List? ?? [],
                  (item) => _buildShopLog(item),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  'Recent Products',
                  Icons.inventory,
                  Colors.orange,
                  logs['recentProducts'] as List? ?? [],
                  (item) => _buildProductLog(item),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  'Recent Orders',
                  Icons.shopping_cart,
                  Colors.purple,
                  logs['recentOrders'] as List? ?? [],
                  (item) => _buildOrderLog(item),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    Color color,
    List items,
    Widget Function(Map<String, dynamic>) builder,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No recent activity'),
            )
          else
            ...items.map((item) => builder(item as Map<String, dynamic>)),
        ],
      ),
    );
  }

  Widget _buildUserLog(Map<String, dynamic> user) {
    final createdAt = DateTime.parse(user['createdAt']);
    return ListTile(
      leading: const Icon(Icons.person_add),
      title: Text(user['name'] ?? 'Unknown'),
      subtitle: Text(user['email'] ?? ''),
      trailing: Text(
        DateFormat('MMM dd, HH:mm').format(createdAt),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildShopLog(Map<String, dynamic> shop) {
    final createdAt = DateTime.parse(shop['createdAt']);
    return ListTile(
      leading: const Icon(Icons.store_mall_directory),
      title: Text(shop['name'] ?? 'Unknown'),
      subtitle: Text(shop['address'] ?? ''),
      trailing: Text(
        DateFormat('MMM dd, HH:mm').format(createdAt),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildProductLog(Map<String, dynamic> product) {
    final createdAt = DateTime.parse(product['createdAt']);
    return ListTile(
      leading: const Icon(Icons.add_shopping_cart),
      title: Text(product['name'] ?? 'Unknown'),
      subtitle: Text('₹${product['price']}'),
      trailing: Text(
        DateFormat('MMM dd, HH:mm').format(createdAt),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildOrderLog(Map<String, dynamic> order) {
    final createdAt = DateTime.parse(order['createdAt']);
    final status = order['status'] ?? 'pending';
    
    Color statusColor = Colors.orange;
    if (status == 'completed') statusColor = Colors.green;
    if (status == 'cancelled') statusColor = Colors.red;

    return ListTile(
      leading: Icon(Icons.receipt, color: statusColor),
      title: Text('Order #${order['_id'].substring(0, 8)}'),
      subtitle: Text('₹${order['totalAmount']} • $status'),
      trailing: Text(
        DateFormat('MMM dd, HH:mm').format(createdAt),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
