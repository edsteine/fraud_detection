import 'package:flutter/material.dart';
import 'package:fraud_mobile/providers/transaction_search_delegate.dart';
import 'package:fraud_mobile/routes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fraud_mobile/providers/transaction_provider.dart';
import 'package:fraud_mobile/providers/user_provider.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Load transactions and user profile from backend
    await context.read<TransactionProvider>().loadTransactions();
    await context.read<UserProvider>().loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final userProvider = context.watch<UserProvider>();

    // Show loading indicator while data is being fetched
    if (transactionProvider.isLoading || userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 0,
        title: Text('Dashboard', style: TextStyle(color: Colors.grey[400])),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blue),
            onPressed: () => showSearch(
              context: context,
              delegate: TransactionSearchDelegate(transactionProvider),
            ),
          ),
          IconButton(
            icon: CircleAvatar(
              backgroundImage: userProvider.userProfile?.imageUrl != null
                ? NetworkImage(userProvider.userProfile!.imageUrl!) // Use user profile image if available
                : const AssetImage('assets/profile_image.jpg'), // Fallback image
              radius: 15,
            ),
            onPressed: () => Navigator.of(context).pushReplacementNamed(Routes.profileRoute), // Navigate to profile view
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData, // Trigger the refresh action
        child: _buildDashboardBody(transactionProvider),
      ),
    );
  }

  Widget _buildDashboardBody(TransactionProvider transactionProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      physics: const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16.0),
          _buildOverviewCards(),
          const SizedBox(height: 32.0),
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16.0),
          _buildRecentTransactions(transactionProvider),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCard(
          title: 'Total Balance',
          value: '\$12,345.67',
          icon: Icons.account_balance_wallet,
          color: Colors.greenAccent,
        ),
        _buildCard(
          title: 'Transactions',
          value: '1,234',
          icon: Icons.swap_horiz,
          color: Colors.orangeAccent,
        ),
        _buildCard(
          title: 'Fraud Alerts',
          value: '5',
          icon: Icons.warning,
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

 Widget _buildRecentTransactions(TransactionProvider transactionProvider) {
  if (transactionProvider.transactions.isEmpty) {
    return const Text('No transactions found', style: TextStyle(color: Colors.white));
  }

  return Column(
    children: transactionProvider.transactions.map((transaction) {
      return Card(
        color: const Color(0xFF2A2A3A),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
          title: Text(
            transaction.description ?? 'No Description',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            transaction.date != null
              ? DateFormat('yyyy-MM-dd').format(transaction.date!)
              : 'No Date',
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: Text(
            '\$${transaction.amount!.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.greenAccent),
          ),
          // Use Navigator.pushNamed to navigate using named routes
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.transactionDetailRoute,
              arguments: transaction.transactionId.toString(), // Pass the transaction ID
            );
          },
        ),
      );
    }).toList(),
  );
}

}
