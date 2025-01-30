import 'package:flutter/material.dart';
import 'firestore_service.dart'; // Import the FirestoreService class
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class CouponManagementScreen extends StatefulWidget {
  @override
  _CouponManagementScreenState createState() => _CouponManagementScreenState();
}

class _CouponManagementScreenState extends State<CouponManagementScreen> {
  final FirestoreService _firestoreService = FirestoreService();
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
                    'Coupon Management',
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
                    'Manage your coupons and discounts',
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
                        hintText: 'Type to search coupons...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Coupon List
                  _buildCouponList(),
                  SizedBox(height: 20),
                  // Add Coupon button
                  ElevatedButton(
                    onPressed: () {
                      _showAddCouponDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Add Coupon',
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

  Widget _buildCouponList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getCoupons(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Map<String, dynamic>> filteredCoupons = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> coupon = doc.data() as Map<String, dynamic>;
          coupon['id'] = doc.id;
          return coupon;
        }).where((coupon) {
          bool matchesSearch = true;

          if (_searchController.text.isNotEmpty) {
            matchesSearch = coupon['code'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
                coupon['discount'].toLowerCase().contains(_searchController.text.toLowerCase());
          }

          return matchesSearch;
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
              Text(
                'Coupon List',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),
              ...filteredCoupons.map((coupon) => _buildCouponItem(coupon)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCouponItem(Map<String, dynamic> coupon) {
    bool isActive = _isCouponActive(coupon['expiry']);

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
                  coupon['code'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  coupon['discount'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Expires on: ${coupon['expiry']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                isActive ? 'Active' : 'Expired',
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _showEditCouponDialog(context, coupon);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteCouponDialog(context, coupon);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isCouponActive(String expiryDate) {
    DateTime expiry = DateTime.parse(expiryDate);
    DateTime now = DateTime.now();
    return now.isBefore(expiry);
  }

  void _showAddCouponDialog(BuildContext context) {
    final _codeController = TextEditingController();
    final _discountController = TextEditingController();
    final _expiryController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Coupon'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(labelText: 'Code'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the code';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _discountController,
                    decoration: InputDecoration(labelText: 'Discount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the discount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _expiryController,
                    decoration: InputDecoration(labelText: 'Expiry Date (YYYY-MM-DD)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the expiry date';
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
                  _firestoreService.addCoupon({
                    'code': _codeController.text,
                    'discount': _discountController.text,
                    'expiry': _expiryController.text,
                    'isActive': _isCouponActive(_expiryController.text),
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

  void _showEditCouponDialog(BuildContext context, Map<String, dynamic> coupon) {
    final _codeController = TextEditingController(text: coupon['code']);
    final _discountController = TextEditingController(text: coupon['discount']);
    final _expiryController = TextEditingController(text: coupon['expiry']);
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Coupon'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(labelText: 'Code'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the code';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _discountController,
                    decoration: InputDecoration(labelText: 'Discount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the discount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _expiryController,
                    decoration: InputDecoration(labelText: 'Expiry Date (YYYY-MM-DD)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the expiry date';
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
                  _firestoreService.updateCoupon(coupon['id'], {
                    'code': _codeController.text,
                    'discount': _discountController.text,
                    'expiry': _expiryController.text,
                    'isActive': _isCouponActive(_expiryController.text),
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

  void _showDeleteCouponDialog(BuildContext context, Map<String, dynamic> coupon) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Coupon'),
          content: Text('Are you sure you want to delete ${coupon['code']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestoreService.deleteCoupon(coupon['id']);
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
