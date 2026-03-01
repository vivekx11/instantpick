import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false).loadUsers();
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          if (provider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadUsers(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];
                return _buildUserCard(context, user, provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user, AdminProvider provider) {
    final isActive = user['isActive'] ?? true;
    final createdAt = DateTime.parse(user['createdAt']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.green : Colors.red,
          child: Text(
            user['name']?[0]?.toUpperCase() ?? 'U',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user['name'] ?? 'Unknown'),
        subtitle: Text(user['email'] ?? ''),
        trailing: Chip(
          label: Text(isActive ? 'Active' : 'Blocked'),
          backgroundColor: isActive ? Colors.green.shade100 : Colors.red.shade100,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Phone', user['phone'] ?? 'N/A'),
                _buildInfoRow('User ID', user['_id']),
                _buildInfoRow('Joined', DateFormat('MMM dd, yyyy').format(createdAt)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await _showConfirmDialog(
                            context,
                            isActive ? 'Block User' : 'Unblock User',
                            'Are you sure?',
                          );
                          if (confirm && mounted) {
                            await provider.toggleUserStatus(user['_id']);
                          }
                        },
                        icon: Icon(isActive ? Icons.block : Icons.check_circle),
                        label: Text(isActive ? 'Block' : 'Unblock'),
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
                            'Delete User',
                            'This action cannot be undone!',
                          );
                          if (confirm && mounted) {
                            await provider.deleteUser(user['_id']);
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
