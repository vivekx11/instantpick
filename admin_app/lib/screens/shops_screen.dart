import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadShops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Shops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false).loadShops();
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          if (provider.shops.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadShops(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.shops.length,
              itemBuilder: (context, index) {
                final shop = provider.shops[index];
                return _buildShopCard(context, shop, provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopCard(BuildContext context, Map<String, dynamic> shop, AdminProvider provider) {
    final isActive = shop['isActive'] ?? true;
    final createdAt = DateTime.parse(shop['createdAt']);
    final owner = shop['ownerId'] ?? {};

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.green : Colors.red,
          child: const Icon(Icons.store, color: Colors.white),
        ),
        title: Text(shop['name'] ?? 'Unknown'),
        subtitle: Text(shop['address'] ?? ''),
        trailing: Chip(
          label: Text(isActive ? 'Active' : 'Inactive'),
          backgroundColor: isActive ? Colors.green.shade100 : Colors.red.shade100,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Shop ID', shop['_id']),
                _buildInfoRow('Owner', owner['name'] ?? 'N/A'),
                _buildInfoRow('Phone', owner['phone'] ?? 'N/A'),
                _buildInfoRow('Email', owner['email'] ?? 'N/A'),
                _buildInfoRow('Created', DateFormat('MMM dd, yyyy').format(createdAt)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await _showConfirmDialog(
                            context,
                            isActive ? 'Deactivate Shop' : 'Activate Shop',
                            'Are you sure?',
                          );
                          if (confirm && mounted) {
                            await provider.toggleShopStatus(shop['_id']);
                          }
                        },
                        icon: Icon(isActive ? Icons.block : Icons.check_circle),
                        label: Text(isActive ? 'Deactivate' : 'Activate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isActive ? Colors.orange : Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await _showConfirmDialog(
                            context,
                            'Delete Shop',
                            'This will delete all products too!',
                          );
                          if (confirm && mounted) {
                            await provider.deleteShop(shop['_id']);
                          }
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
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
            width: 80,
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

  Future<bool> _showConfirmDialog(BuildContext context, String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
