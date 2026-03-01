import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false).loadOrders();
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          if (provider.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.orders.length,
              itemBuilder: (context, index) {
                final order = provider.orders[index];
                return _buildOrderCard(context, order, provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order, AdminProvider provider) {
    final status = order['status'] ?? 'pending';
    final createdAt = DateTime.parse(order['createdAt']);
    final user = order['userId'] ?? {};
    final shop = order['shopId'] ?? {};
    final items = order['items'] as List? ?? [];

    Color statusColor = Colors.orange;
    if (status == 'completed') statusColor = Colors.green;
    if (status == 'cancelled') statusColor = Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: const Icon(Icons.shopping_cart, color: Colors.white),
        ),
        title: Text('Order #${order['_id'].substring(0, 8)}'),
        subtitle: Text('${user['name'] ?? 'Unknown'} • ${shop['name'] ?? 'N/A'}'),
        trailing: Chip(
          label: Text(status.toUpperCase()),
          backgroundColor: statusColor.withOpacity(0.2),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Order ID', order['_id']),
                _buildInfoRow('Customer', user['name'] ?? 'N/A'),
                _buildInfoRow('Phone', user['phone'] ?? 'N/A'),
                _buildInfoRow('Shop', shop['name'] ?? 'N/A'),
                _buildInfoRow('Total', '₹${order['totalAmount']}'),
                _buildInfoRow('Date', DateFormat('MMM dd, yyyy HH:mm').format(createdAt)),
                const SizedBox(height: 8),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text('• ${item['name']} x${item['quantity']} - ₹${item['price']}'),
                    )),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: status,
                        decoration: const InputDecoration(
                          labelText: 'Update Status',
                          border: OutlineInputBorder(),
                        ),
                        items: ['pending', 'confirmed', 'ready', 'completed', 'cancelled']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase())))
                            .toList(),
                        onChanged: (newStatus) async {
                          if (newStatus != null && newStatus != status) {
                            await provider.updateOrderStatus(order['_id'], newStatus);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
