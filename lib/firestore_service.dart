import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Management
  // Add user to Firestore
  Future<void> addUser(Map<String, dynamic> data) async {
    try {
      await _db.collection('users').add(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Update user in Firestore
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(userId).update(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Get users from Firestore
  Stream<QuerySnapshot> getUsers() {
    return _db.collection('users').snapshots();
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('users').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Inventory Management
  // Add inventory item to Firestore
  Future<void> addInventoryItem(Map<String, dynamic> data) async {
    try {
      await _db.collection('inventory').add(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Update inventory item in Firestore
  Future<void> updateInventoryItem(String itemId, Map<String, dynamic> data) async {
    try {
      await _db.collection('inventory').doc(itemId).update(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete inventory item from Firestore
  Future<void> deleteInventoryItem(String itemId) async {
    try {
      await _db.collection('inventory').doc(itemId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Get inventory items from Firestore
  Stream<QuerySnapshot> getInventoryItems() {
    return _db.collection('inventory').snapshots();
  }

  // Coupon Management
  // Add coupon to Firestore
  Future<void> addCoupon(Map<String, dynamic> data) async {
    try {
      await _db.collection('coupons').add(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Update coupon in Firestore
  Future<void> updateCoupon(String couponId, Map<String, dynamic> data) async {
    try {
      await _db.collection('coupons').doc(couponId).update(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete coupon from Firestore
  Future<void> deleteCoupon(String couponId) async {
    try {
      await _db.collection('coupons').doc(couponId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Get coupons from Firestore
  Stream<QuerySnapshot> getCoupons() {
    return _db.collection('coupons').snapshots();
  }

  // Sales Report Management
  // Add sales report to Firestore
  Future<void> addSalesReport(Map<String, dynamic> data) async {
    try {
      await _db.collection('sales_reports').add(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Update sales report in Firestore
  Future<void> updateSalesReport(String reportId, Map<String, dynamic> data) async {
    try {
      await _db.collection('sales_reports').doc(reportId).update(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete sales report from Firestore
  Future<void> deleteSalesReport(String reportId) async {
    try {
      await _db.collection('sales_reports').doc(reportId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Get sales reports from Firestore
  Stream<QuerySnapshot> getSalesReports() {
    return _db.collection('sales_reports').snapshots();
  }
}
