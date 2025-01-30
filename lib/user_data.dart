class UserData {
  static List<Map<String, dynamic>> _users = [
    {
      'name': 'bilal',
      'role': 'Admin',
      'email': 'bilal@foodtruck.com',
      'password': 'admin123',
      'isActive': true,
    },
    {
      'name': 'ahmad',
      'role': 'Manager',
      'email': 'ahmad@foodtruck.com',
      'password': 'manager123',
      'isActive': true,
    },
    {
      'name': 'ali',
      'role': 'Staff',
      'email': 'ali@foodtruck.com',
      'password': 'staff123',
      'isActive': true,
    },
  ];

  static List<Map<String, dynamic>> get users => _users;

  static void updateUsers(List<Map<String, dynamic>> newUsers) {
    _users = newUsers;
  }

  static void addUser(Map<String, dynamic> user) {
    _users.add(user);
  }

  static void removeUser(Map<String, dynamic> user) {
    _users.remove(user);
  }

  static void updateUser(Map<String, dynamic> oldUser, Map<String, dynamic> newUser) {
    int index = _users.indexOf(oldUser);
    if (index != -1) {
      _users[index] = newUser;
    }
  }

  static Map<String, dynamic>? getUserByEmail(String email) {
    try {
      return _users.firstWhere(
            (user) => user['email'] == email,
      );
    } catch (e) {
      return null;
    }
  }

  static bool validateUser(String email, String password) {
    Map<String, dynamic>? user = getUserByEmail(email);
    return user != null && user['password'] == password;
  }
}
