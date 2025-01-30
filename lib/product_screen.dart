import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesomeIcons
import 'product_details_screen.dart'; // Import the ProductDetailsScreen

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All Items';
  bool _isSearchFocused = false;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'imagePath': 'assets/classic_burger.png',
      'name': 'Classic Burger',
      'price': '\$8.99',
      'description': 'A juicy beef patty with fresh lettuce, tomatoes, onions, and our special sauce on a toasted brioche bun.',
      'category': 'Burgers',
    },
    {
      'imagePath': 'assets/french_fries.png',
      'name': 'French Fries',
      'price': '\$3.99',
      'description': 'Crispy golden fries seasoned to perfection.',
      'category': 'Sides',
    },
    {
      'imagePath': 'assets/chicken_sandwich.png',
      'name': 'Chicken Sandwich',
      'price': '\$7.99',
      'description': 'Grilled chicken breast with lettuce, tomatoes, and mayo on a soft bun.',
      'category': 'Burgers',
    },
    {
      'imagePath': 'assets/soft_drink.png',
      'name': 'Soft Drink',
      'price': '\$1.99',
      'description': 'Refreshing soft drink to quench your thirst.',
      'category': 'Drinks',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    return _menuItems.where((item) {
      bool matchesCategory = _selectedCategory == 'All Items' || item['category'] == _selectedCategory;
      bool matchesSearch = item['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

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
                  mainAxisSize: MainAxisSize.min,
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
                      'Food Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    SizedBox(height: 20),
                    // Search bar
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 320),
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextField(
                        style: TextStyle(color: _isSearchFocused ? Colors.black : Colors.grey[600]),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _isSearchFocused ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.5),
                          hintText: 'Search menu items...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onTap: () {
                          setState(() {
                            _isSearchFocused = true;
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            _isSearchFocused = false;
                          });
                        },
                      ),
                    ),
                    // Category buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryButton(context, 'All Items', true),
                          _buildCategoryButton(context, 'Burgers', false),
                          _buildCategoryButton(context, 'Sides', false),
                          _buildCategoryButton(context, 'Drinks', false),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Menu items
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 3 / 4,
                          children: _filteredItems.map((item) {
                            return _buildMenuItem(
                              context,
                              item['imagePath'],
                              item['name'],
                              item['price'],
                              item['description'],
                            );
                          }).toList(),
                        );
                      },
                    ),
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

  Widget _buildCategoryButton(BuildContext context, String title, bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = title;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.orange : Colors.white.withOpacity(0.9),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String imagePath, String name, String price, String description) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              imagePath: imagePath,
              title: name,
              description: description,
              price: price,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
