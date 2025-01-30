import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coupon_management.dart'; // Import the CouponManagement class
import 'cart_model.dart'; // Import the Cart model

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _billingNameController = TextEditingController();
  final _billingAddressController = TextEditingController();
  final _billingZipController = TextEditingController();
  final _billingCityController = TextEditingController();
  String? _selectedState;
  String? _selectedMonth;
  String? _selectedYear;
  String? _billingState;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  SizedBox(height: 20),
                  // Payment Methods
                  _buildPaymentMethods(),
                  SizedBox(height: 20),
                  // Coupon Code Section
                  CouponManagement(),
                  SizedBox(height: 20),
                  // Show relevant form based on the selected payment method
                  if (_selectedPaymentMethod != null) _buildFormForSelectedMethod(),
                  SizedBox(height: 20),
                  // Card-like layout for final product summary
                  _buildFinalProductSummary(cart),
                  SizedBox(height: 20),
                  // Confirm Payment button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle the confirmation based on selected payment method
                        Navigator.pushNamed(context, '/payment_processing');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Confirm Payment',
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

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentMethod('Credit Card', Icons.credit_card, Colors.blue),
        SizedBox(height: 10),
        _buildPaymentMethod('PayPal', Icons.paypal, Colors.teal),
        SizedBox(height: 10),
        _buildPaymentMethod('Cash on Delivery', Icons.money, Colors.green),
      ],
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = title; // Update the selected payment method
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10.0,
              spreadRadius: 5.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          selected: _selectedPaymentMethod == title, // Highlight the selected payment method
          onTap: () {
            setState(() {
              _selectedPaymentMethod = title;
            });
          },
        ),
      ),
    );
  }

  Widget _buildFormForSelectedMethod() {
    switch (_selectedPaymentMethod) {
      case 'Credit Card':
      case 'PayPal':
        return _buildCreditCardOrPayPalForm();
      case 'Cash on Delivery':
        return _buildShippingForm();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildCreditCardOrPayPalForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Information Section
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light grey background
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            padding: EdgeInsets.all(16.0), // Add padding inside the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                // Cardholder Name
                TextFormField(
                  controller: _cardholderNameController,
                  decoration: InputDecoration(labelText: 'Cardholder Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the cardholder name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Card Number
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 16) {
                      return 'Please enter a valid 16-digit card number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Expiration Date
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedMonth,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedMonth = newValue;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Month'),
                        items: List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'))
                            .map((month) => DropdownMenuItem(value: month, child: Text(month)))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a month';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedYear,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedYear = newValue;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Year'),
                        items: List.generate(10, (index) => (DateTime.now().year + index).toString())
                            .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a year';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // CVV/CVC Code
                TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(labelText: 'CVV/CVC Code'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3 || value.length > 4) {
                      return 'Please enter a valid CVV/CVC code';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Billing Address Section
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light grey background
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            padding: EdgeInsets.all(16.0), // Add padding inside the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Billing Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _billingNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the full name for billing';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _billingAddressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the billing address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _billingZipController,
                  decoration: InputDecoration(labelText: 'Pin/Zip Code'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the billing zip code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _billingCityController,
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the billing city';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _billingState,
                  onChanged: (newValue) {
                    setState(() {
                      _billingState = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Province'),
                  items: ['PUNJAB', 'SINDH', 'BALOCHISTAN', 'FATA', 'KPK'].map((province) {
                    return DropdownMenuItem<String>(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select the billing province';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingForm() {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Light grey background
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        padding: EdgeInsets.all(16.0), // Add padding inside the container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            // Full Name Text Field
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            // Mobile Number Text Field
            TextFormField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            // Delivery Address Text Field
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Delivery Address'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your delivery address';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            // Pin/Zip Code Text Field
            TextFormField(
              controller: _zipController,
              decoration: InputDecoration(labelText: 'Pin/Zip Code'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Pin/Zip Code';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            // City Text Field
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            // Province Dropdown
            DropdownButtonFormField<String>(
              value: _selectedState,
              onChanged: (newValue) {
                setState(() {
                  _selectedState = newValue;
                });
              },
              decoration: InputDecoration(labelText: 'Province'),
              items: ['PUNJAB', 'SINDH', 'BALOCHISTAN', 'FATA', 'KPK'].map((province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select your province';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalProductSummary(Cart cart) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Items: ${cart.items.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Subtotal: \$${cart.subTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tax (5%): \$${cart.tax.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Total: \$${cart.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
