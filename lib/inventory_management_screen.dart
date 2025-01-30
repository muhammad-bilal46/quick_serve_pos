import 'package:flutter/material.dart';
import 'firestore_service.dart'; // Import the FirestoreService class
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class InventoryManagementScreen extends StatefulWidget {
  @override
  _InventoryManagementScreenState createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedFilter = 'All Items';
  final TextEditingController _searchController = TextEditingController();

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
          SafeArea(
            child: Center(
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
                      'Inventory Management',
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
                      'Easily track and manage your food truck inventory items',
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterButton('All Items'),
                          _buildFilterButton('Low Stock'),
                          _buildFilterButton('Out of Stock'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Inventory Status
                    _buildInventoryStatus(),
                    SizedBox(height: 20),
                    // Inventory Items
                    _buildInventoryItems(),
                    SizedBox(height: 20),
                    // Logout button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/role_selection');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedFilter == title ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryStatus() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getInventoryItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        int lowStockCount = snapshot.data!.docs.where((doc) => doc['stock'] <= 5).length;
        int outOfStockCount = snapshot.data!.docs.where((doc) => doc['stock'] == 0).length;

        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Low Stock: $lowStockCount, Out of Stock: $outOfStockCount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInventoryItems() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getInventoryItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Map<String, dynamic>> filteredItems = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> item = doc.data() as Map<String, dynamic>;
          item['id'] = doc.id;
          return item;
        }).where((item) {
          bool matchesFilter = true;
          bool matchesSearch = true;

          if (_selectedFilter == 'Low Stock') {
            matchesFilter = item['stock'] <= 5;
          } else if (_selectedFilter == 'Out of Stock') {
            matchesFilter = item['stock'] == 0;
          }

          if (_searchController.text.isNotEmpty) {
            matchesSearch = item['name'].toLowerCase().contains(_searchController.text.toLowerCase());
          }

          return matchesFilter && matchesSearch;
        }).toList();

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
                    'Inventory Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showAddItemDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Add New Item',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ...filteredItems.map((item) => _buildInventoryItem(item)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInventoryItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Stock: ${item['stock']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showEditItemDialog(context, item);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteItemDialog(context, item);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _stockController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(labelText: 'Stock'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the stock';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _firestoreService.addInventoryItem({
                    'name': _nameController.text,
                    'stock': int.parse(_stockController.text),
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(BuildContext context, Map<String, dynamic> item) {
    final _nameController = TextEditingController(text: item['name']);
    final _stockController = TextEditingController(text: item['stock'].toString());
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(labelText: 'Stock'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the stock';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _firestoreService.updateInventoryItem(item['id'], {
                    'name': _nameController.text,
                    'stock': int.parse(_stockController.text),
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteItemDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete ${item['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestoreService.deleteInventoryItem(item['id']);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
