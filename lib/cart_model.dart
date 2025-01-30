import 'package:flutter/material.dart';

class CartItem {
  final String imagePath;
  final String title;
  final double price;
  int quantity;

  CartItem({
    required this.imagePath,
    required this.title,
    required this.price,
    this.quantity = 1,
  });
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];
  double _discount = 0.0; // Add discount field

  List<CartItem> get items => _items;

  double get subTotal => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get tax => subTotal * 0.05; // 5% tax
  double get total => subTotal + tax - _discount; // Subtract discount from total

  double get discount => _discount; // Getter for discount

  void addItem(CartItem item) {
    final existingItem = _items.firstWhere(
          (element) => element.title == item.title,
      orElse: () => CartItem(
        imagePath: '',
        title: '',
        price: 0,
      ),
    );

    if (existingItem.title.isNotEmpty) {
      existingItem.quantity += item.quantity;
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  void applyDiscount(double discount) {
    _discount = discount; // Apply discount
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    } else {
      _items.remove(item);
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;
}
