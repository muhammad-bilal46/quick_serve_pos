class InventoryData {
  static List<Map<String, dynamic>> _inventoryItems = [
    {
      'name': 'Classic Burger',
      'stock': 3,
    },
    {
      'name': 'French Fries',
      'stock': 45,
    },
    {
      'name': 'Soft Drinks',
      'stock': 10,
    },
  ];

  static List<Map<String, dynamic>> get inventoryItems => _inventoryItems;

  static void updateInventoryItems(List<Map<String, dynamic>> newItems) {
    _inventoryItems = newItems;
  }

  static void addInventoryItem(Map<String, dynamic> item) {
    _inventoryItems.add(item);
  }

  static void removeInventoryItem(Map<String, dynamic> item) {
    _inventoryItems.remove(item);
  }

  static void updateInventoryItem(Map<String, dynamic> oldItem, Map<String, dynamic> newItem) {
    int index = _inventoryItems.indexOf(oldItem);
    if (index != -1) {
      _inventoryItems[index] = newItem;
    }
  }
}
