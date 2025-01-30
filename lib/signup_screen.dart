import 'package:flutter/material.dart';
import 'firestore_service.dart'; // Import the FirestoreService class

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedRole = 'Staff'; // Default role for new users

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
              child: Form(
                key: _formKey,
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
                    // Create Your Account text
                    Text(
                      'Create Your Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Full Name input
                    TextFormField(
                      controller: _fullNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your full name'
                          : null,
                    ),
                    SizedBox(height: 10),
                    // Email input
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your email'
                          : null,
                    ),
                    SizedBox(height: 10),
                    // Phone Number input
                    TextFormField(
                      controller: _phoneNumberController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your phone number'
                          : null,
                    ),
                    SizedBox(height: 10),
                    // Password input
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your password'
                          : null,
                    ),
                    SizedBox(height: 10),
                    // Confirm Password input
                    TextFormField(
                      controller: _confirmPasswordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please confirm your password'
                          : null,
                    ),
                    SizedBox(height: 20),
                    // Role selection
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Role',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
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
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select the role'
                          : null,
                    ),
                    SizedBox(height: 20),
                    // Create Account button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signup(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Social login buttons
                    Text(
                      'or continue with',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/google_icon.png'),
                          onPressed: () {
                            _signupWithGoogle();
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/facebook_icon.png'),
                          onPressed: () {
                            _signupWithFacebook();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Already have an account? Login
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(color: Colors.white),
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

  void _signup(BuildContext context) {
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Add user to Firestore
    _firestoreService.addUser({
      'name': fullName,
      'role': _selectedRole, // Role selected during signup
      'email': email,
      'password': password,
      'isActive': true,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signup successful! Please verify your account.')),
    );

    Navigator.pushReplacementNamed(context, '/verification');
  }

  void _signupWithGoogle() {
    // Placeholder for Google sign-up logic
    print('Signup with Google');
  }

  void _signupWithFacebook() {
    // Placeholder for Facebook sign-up logic
    print('Signup with Facebook');
  }
}
