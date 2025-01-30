import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart'; // Import the LoginScreen class
import 'signup_screen.dart'; // Import the SignupScreen class
import 'verification_screen.dart'; // Import the VerificationScreen class
import 'role_selection_screen.dart'; // Import the RoleSelectionScreen class
import 'admin_dashboard_screen.dart'; // Import the AdminDashboardScreen class
import 'product_screen.dart'; // Import the ProductScreen class
import 'product_details_screen.dart'; // Import the ProductDetailsScreen class
import 'cart_screen.dart'; // Import the CartScreen class
import 'checkout_screen.dart'; // Import the CheckoutScreen class
import 'payment_screen.dart'; // Import the PaymentScreen class
import 'payment_processing_screen.dart'; // Import the PaymentProcessingScreen class
import 'order_confirmation_screen.dart'; // Import the OrderConfirmationScreen class
import 'sales_report_screen.dart'; // Import the SalesReportScreen class
import 'inventory_management_screen.dart'; // Import the InventoryManagementScreen class
import 'user_management_screen.dart'; // Import the UserManagementScreen class
import 'coupon_management_screen.dart'; // Import the CouponManagementScreen class
import 'cart_model.dart'; // Import the Cart model
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: 'QuickServe POS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/verification': (context) => VerificationScreen(),
          '/role_selection': (context) => RoleSelectionScreen(),
          '/admin_dashboard': (context) => AdminDashboardScreen(),
          '/staff_dashboard': (context) => ProductScreen(), // Route for ProductScreen
          '/manager_dashboard': (context) => InventoryManagementScreen(),
          '/product_details': (context) => ProductDetailsScreen(
            imagePath: '',
            title: '',
            description: '',
            price: '',
          ),
          '/cart': (context) => CartScreen(),
          '/checkout': (context) => CheckoutScreen(),
          '/payment': (context) => PaymentScreen(),
          '/payment_processing': (context) => PaymentProcessingScreen(),
          '/order_confirmation': (context) => OrderConfirmationScreen(),
          '/sales_report': (context) => SalesReportScreen(),
          '/inventory_management': (context) => InventoryManagementScreen(),
          '/user_management': (context) => UserManagementScreen(),
          '/coupon_management': (context) => CouponManagementScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToRoleSelection();
  }

  _navigateToRoleSelection() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacementNamed(context, '/role_selection');
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
          Center(
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
                  'QuickServe POS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Subtitle
                Text(
                  'Powering Your Food Truck',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                // Indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IndicatorDot(isActive: true),
                    IndicatorDot(isActive: false),
                    IndicatorDot(isActive: false),
                  ],
                ),
              ],
            ),
          ),
          // Bottom navigation indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IndicatorDot extends StatelessWidget {
  final bool isActive;

  IndicatorDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      width: isActive ? 12.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
      ),
    );
  }
}
