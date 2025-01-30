import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart'; // Import the Cart model

class CouponManagement extends StatelessWidget {
  final _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Column(
      children: [
        TextField(
          controller: _couponController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter coupon code',
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_couponController.text.isNotEmpty) {
              double discount = cart.subTotal * 0.05;
              cart.applyDiscount(discount);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Coupon applied! Discount of \$${discount.toStringAsFixed(2)} applied.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Apply Coupon',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
