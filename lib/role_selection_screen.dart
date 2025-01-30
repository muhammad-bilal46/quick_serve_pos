import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
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
                    'Select Your Role',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  SizedBox(height: 20),
                  // Description
                  Text(
                    'Choose your access level for QuickServe POS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  // Role cards
                  _buildRoleCard(
                    context,
                    'assets/admin_icon.png',
                    'Admin',
                    'Full system control, manage staff, view reports and configure settings',
                    '/login', // Navigate to login screen
                    'admin', // Associated role (lowercase for consistency)
                  ),
                  SizedBox(height: 20),
                  _buildRoleCard(
                    context,
                    'assets/cashier_icon.png',
                    'Cashier',
                    'Process orders, handle payments, and manage daily transactions',
                    '/login', // Navigate to login screen
                    'staff', // Associated role (lowercase for consistency)
                  ),
                  SizedBox(height: 20),
                  _buildRoleCard(
                    context,
                    'assets/inventory_manager_icon.png',
                    'Inventory Manager',
                    'Track stock levels, manage supplies, and handle inventory reports',
                    '/login', // Navigate to login screen
                    'manager', // Associated role (lowercase for consistency)
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
      BuildContext context, String imagePath, String title, String description, String loginRoute, String associatedRole) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, loginRoute, arguments: associatedRole);
      },
      child: Container(
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
              children: [
                Image.asset(
                  imagePath,
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
