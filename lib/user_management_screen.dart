import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesomeIcons
import 'firestore_service.dart'; // Import the FirestoreService class
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedFilter = 'All Users';
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
                    'User Management',
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
                    'Manage your food truck staff and their access levels',
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
                        hintText: 'Type to search users...',
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
                        _buildFilterButton('All Users'),
                        _buildFilterButton('Admins'),
                        _buildFilterButton('Managers'),
                        _buildFilterButton('Staff'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // User List
                  _buildUserList(),
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
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            if (title == 'All Users')
              Icon(FontAwesomeIcons.users, color: _selectedFilter == title ? Colors.white : Colors.grey[800], size: 16),
            if (title == 'Admins')
              Icon(FontAwesomeIcons.userShield, color: _selectedFilter == title ? Colors.white : Colors.grey[800], size: 16),
            if (title == 'Managers')
              Icon(FontAwesomeIcons.userTie, color: _selectedFilter == title ? Colors.white : Colors.grey[800], size: 16),
            if (title == 'Staff')
              Icon(FontAwesomeIcons.user, color: _selectedFilter == title ? Colors.white : Colors.grey[800], size: 16),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: _selectedFilter == title ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Map<String, dynamic>> filteredUsers = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> user = doc.data() as Map<String, dynamic>;
          user['id'] = doc.id;
          return user;
        }).where((user) {
          bool matchesFilter = true;
          bool matchesSearch = true;

          if (_selectedFilter != 'All Users') {
            matchesFilter = user['role'] == (_selectedFilter == 'Admins' ? 'Admin' : _selectedFilter == 'Managers' ? 'Manager' : 'Staff');
          }

          if (_searchController.text.isNotEmpty) {
            matchesSearch = user['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
                user['email'].toLowerCase().contains(_searchController.text.toLowerCase());
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
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      '${filteredUsers.length} users',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Staff Members',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showCreateUserDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.userPlus,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Create User',
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
              ...filteredUsers.map((user) => _buildUserItem(context, user)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserItem(BuildContext context, Map<String, dynamic> user) {
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
                  user['name'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  user['email'],
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: _getRoleColor(user['role']),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  user['role'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  _toggleUserStatus(user);
                },
                child: Text(
                  user['isActive'] ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 12,
                    color: user['isActive'] ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showEditUserDialog(context, user);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteUserDialog(context, user);
                },
              ),
              IconButton(
                icon: Icon(Icons.lock, color: Colors.purple),
                onPressed: () {
                  _showChangePasswordDialog(context, user);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.blue.shade100;
      case 'Manager':
        return Colors.green.shade100;
      case 'Staff':
        return Colors.grey.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _showCreateUserDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String? _selectedRole;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create User'),
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
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Role'),
                    value: _selectedRole,
                    items: ['Admin', 'Manager', 'Staff'].map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the role';
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
                  _firestoreService.addUser({
                    'name': _nameController.text,
                    'role': _selectedRole!,
                    'email': _emailController.text,
                    'isActive': true,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, Map<String, dynamic> user) {
    final _nameController = TextEditingController(text: user['name']);
    final _emailController = TextEditingController(text: user['email']);
    final _formKey = GlobalKey<FormState>();
    String? _selectedRole = user['role'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
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
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Role'),
                    value: _selectedRole,
                    items: ['Admin', 'Manager', 'Staff'].map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the role';
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
                  _firestoreService.updateUser(user['id'], {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'role': _selectedRole!,
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

  void _showDeleteUserDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete ${user['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestoreService.deleteUser(user['id']);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    _firestoreService.updateUser(user['id'], {
      'isActive': !user['isActive'],
    });
  }

  void _showChangePasswordDialog(BuildContext context, Map<String, dynamic> user) {
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the new password';
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
                  _firestoreService.updateUser(user['id'], {
                    'password': _passwordController.text,
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
}
