import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesomeIcons
import 'inventory_data.dart'; // Import the centralized data management class

class AdminDashboardScreen extends StatelessWidget {
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
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  SizedBox(height: 20),
                  // Welcome text
                  Text(
                    'Welcome back, Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  // Statistics cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(context, FontAwesomeIcons.chartLine, 'Today\'s Sales', '\$1,234', '+15% vs yesterday'),
                      _buildStatCard(context, FontAwesomeIcons.shoppingCart, 'Orders', '48', '12 pending'),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Action buttons
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildActionCard(context, FontAwesomeIcons.box, 'Manage Products'),
                          _buildActionCard(context, FontAwesomeIcons.users, 'Manage Users'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildActionCard(context, FontAwesomeIcons.ticketAlt, 'Coupons'),
                          _buildActionCard(context, FontAwesomeIcons.chartBar, 'View Reports'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Inventory status
                  _buildInventoryStatus(context),
                  SizedBox(height: 20),
                  // Logout button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/role_selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String title, String value, String subtitle) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              FaIcon(
                icon,
                size: 24,
                color: Colors.orange, // Customize the color as needed
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange, // Customize the color as needed
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Manage Products') {
          Navigator.pushNamed(context, '/inventory_management');
        } else if (title == 'View Reports') {
          Navigator.pushNamed(context, '/sales_report');
        } else if (title == 'Manage Users') {
          Navigator.pushNamed(context, '/user_management');
        } else if (title == 'Coupons') {
          Navigator.pushNamed(context, '/coupon_management');
        }
        // Handle other button presses
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 60) / 2,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            FaIcon(
              icon,
              size: 32,
              color: Colors.orange, // Customize the color as needed
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryStatus(BuildContext context) {
    List<Map<String, dynamic>> inventoryItems = InventoryData.inventoryItems;
    int lowStockCount = inventoryItems.where((item) => item['stock'] <= 5).length;
    int outOfStockCount = inventoryItems.where((item) => item['stock'] == 0).length;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inventory Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              FaIcon(
                FontAwesomeIcons.boxes,
                size: 24,
                color: Colors.orange, // Customize the color as needed
              ),
            ],
          ),
          SizedBox(height: 16),
          ...inventoryItems.map((item) => _buildInventoryItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(Map<String, dynamic> item) {
    String status;
    Color statusColor;

    if (item['stock'] == 0) {
      status = 'Out of Stock';
      statusColor = Colors.red;
    } else if (item['stock'] <= 5) {
      status = 'Low Stock';
      statusColor = Colors.orange;
    } else {
      status = 'In Stock';
      statusColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item['name'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
