import 'package:flutter/material.dart';

class SalesReportScreen extends StatefulWidget {
  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  String _selectedFilter = 'Daily';
  final TextEditingController _searchController = TextEditingController();

  // Sample data for demonstration
  List<Map<String, dynamic>> _salesData = [
    {
      'date': '2024-01-01',
      'totalSales': 1458.0,
      'orders': 47,
      'avgOrderValue': 31.0,
      'itemsSold': 142,
      'topSellingItems': [
        {'item': 'Classic Burger', 'quantity': 84},
        {'item': 'French Fries', 'quantity': 76},
        {'item': 'Chicken Wings', 'quantity': 58},
      ],
      'lowStockItems': [
        {'item': 'Burger Buns', 'quantity': 5},
        {'item': 'Cheese Slices', 'quantity': 15},
        {'item': 'Tomatoes', 'quantity': 20},
      ],
    },
    // Add more data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Centered content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo.png',
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(height: 20),
                  // Title
                  Text(
                    'Sales Reports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  SizedBox(height: 20),
                  // Subtitle
                  Text(
                    'Track your food truck performance and analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Search bar
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Type to search items...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Filter buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFilterButton('Daily'),
                      _buildFilterButton('Weekly'),
                      _buildFilterButton('Monthly'),
                    ],
                  ),
                  SizedBox(height: 20),
                  // User List
                  _buildUserList(),
                  SizedBox(height: 20),
                  // Today's Summary
                  _buildTodaysSummary(),
                  SizedBox(height: 20),
                  // Top Selling Items
                  _buildTopSellingItems(),
                  SizedBox(height: 20),
                  // Low Stock Alert
                  _buildLowStockAlert(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: _selectedFilter == title ? Colors.orange : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedFilter == title ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User List',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '5 users',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Add user list items here
        ],
      ),
    );
  }

  Widget _buildTodaysSummary() {
    // Filter sales data based on the selected filter
    List<Map<String, dynamic>> filteredData = _salesData.where((data) {
      DateTime date = DateTime.parse(data['date']);
      DateTime now = DateTime.now();
      switch (_selectedFilter) {
        case 'Daily':
          return date.year == now.year && date.month == now.month && date.day == now.day;
        case 'Weekly':
          return date.year == now.year && date.month == now.month && date.weekday == now.weekday;
        case 'Monthly':
          return date.year == now.year && date.month == now.month;
        default:
          return false;
      }
    }).toList();

    // Summarize the filtered data
    double totalSales = filteredData.fold(0.0, (sum, data) => sum + (data['totalSales'] as num).toDouble());
    int orders = filteredData.fold(0, (sum, data) => sum + (data['orders'] as num).toInt());
    double avgOrderValue = filteredData.isNotEmpty ? totalSales / orders : 0;
    int itemsSold = filteredData.fold(0, (sum, data) => sum + (data['itemsSold'] as num).toInt());

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total Sales', '\$${totalSales.toStringAsFixed(2)}', Colors.blue),
              _buildSummaryItem('Orders', orders.toString(), Colors.green),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Avg Order Value', '\$${avgOrderValue.toStringAsFixed(2)}', Colors.purple),
              _buildSummaryItem('Items Sold', itemsSold.toString(), Colors.orange),
            ],
          ),
          SizedBox(height: 16),
          Text(
            DateTime.now().toString().split(' ')[0],
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTopSellingItems() {
    // Filter sales data based on the selected filter
    List<Map<String, dynamic>> filteredData = _salesData.where((data) {
      DateTime date = DateTime.parse(data['date']);
      DateTime now = DateTime.now();
      switch (_selectedFilter) {
        case 'Daily':
          return date.year == now.year && date.month == now.month && date.day == now.day;
        case 'Weekly':
          return date.year == now.year && date.month == now.month && date.weekday == now.weekday;
        case 'Monthly':
          return date.year == now.year && date.month == now.month;
        default:
          return false;
      }
    }).toList();

    // Aggregate top selling items
    Map<String, int> topSellingItems = {};
    for (var data in filteredData) {
      for (var item in data['topSellingItems']) {
        topSellingItems[item['item']] = (topSellingItems[item['item']] ?? 0) + (item['quantity'] as num).toInt();
      }
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Selling Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          ...topSellingItems.entries.map((entry) => _buildSellingItem(entry.key, '${entry.value} sold')).toList(),
        ],
      ),
    );
  }

  Widget _buildSellingItem(String item, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockAlert() {
    // Filter sales data based on the selected filter
    List<Map<String, dynamic>> filteredData = _salesData.where((data) {
      DateTime date = DateTime.parse(data['date']);
      DateTime now = DateTime.now();
      switch (_selectedFilter) {
        case 'Daily':
          return date.year == now.year && date.month == now.month && date.day == now.day;
        case 'Weekly':
          return date.year == now.year && date.month == now.month && date.weekday == now.weekday;
        case 'Monthly':
          return date.year == now.year && date.month == now.month;
        default:
          return false;
      }
    }).toList();

    // Aggregate low stock items
    Map<String, int> lowStockItems = {};
    for (var data in filteredData) {
      for (var item in data['lowStockItems']) {
        lowStockItems[item['item']] = (lowStockItems[item['item']] ?? 0) + (item['quantity'] as num).toInt();
      }
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Low Stock Alert',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          ...lowStockItems.entries.map((entry) => _buildStockItem(entry.key, '${entry.value} left', Colors.red)).toList(),
        ],
      ),
    );
  }

  Widget _buildStockItem(String item, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
