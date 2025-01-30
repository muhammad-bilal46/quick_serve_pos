import 'package:flutter/material.dart';

class PaymentProcessingScreen extends StatefulWidget {
  @override
  _PaymentProcessingScreenState createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  String _paymentStatus = 'Processing...';

  @override
  void initState() {
    super.initState();
    _processPayment();
  }

  Future<void> _processPayment() async {
    // Simulate payment processing delay
    await Future.delayed(Duration(seconds: 3));

    // Simulate payment result
    bool isPaymentSuccessful = true; // Change this to false to simulate failure

    setState(() {
      if (isPaymentSuccessful) {
        _paymentStatus = 'Payment Successful!';
      } else {
        _paymentStatus = 'Payment Failed. Please try again.';
      }
    });

    // Simulate navigation delay
    await Future.delayed(Duration(seconds: 2));

    if (isPaymentSuccessful) {
      Navigator.pushReplacementNamed(context, '/order_confirmation');
    } else {
      Navigator.pop(context);
    }
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
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                // Title
                Text(
                  'Payment Processing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Message
                Text(
                  'Please wait while we securely process your payment through our encrypted system',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Loading spinner
                if (_paymentStatus == 'Processing...')
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                else
                  Text(
                    _paymentStatus,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
                // Transaction details card
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Processing Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Securely connecting to payment gateway...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'Your transaction is protected by 256-bit encryption',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(color: Colors.grey[300]),
                        SizedBox(height: 10),
                        Text(
                          'Transaction ID: #123456789',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Amount: \$45.99',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Merchant: QuickServe Food Truck',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
