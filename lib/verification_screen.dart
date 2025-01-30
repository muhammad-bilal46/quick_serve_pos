import 'package:flutter/material.dart';
import 'dart:async';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _verificationCode = '';
  int _countdownTime = 119; // 1 minute and 59 seconds
  late Timer _timer;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (!_isTimerRunning) {
      _isTimerRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownTime > 0) {
            _countdownTime--;
          } else {
            _timer.cancel();
            _isTimerRunning = false;
          }
        });
      });
    }
  }

  String _formatCountdownTime() {
    int minutes = _countdownTime ~/ 60;
    int seconds = _countdownTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
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
                  // Enter Verification Code text
                  Text(
                    'Enter Verification Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  // OTP input fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < 4; i++)
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: TextField(
                            controller: _pinController,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, color: Colors.white),
                            decoration: InputDecoration(
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                              setState(() {
                                _verificationCode += value;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Resend OTP text
                  Text(
                    'Resend OTP in ${_formatCountdownTime()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  // Verify button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/role_selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Verify',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Didn't receive code? Resend
                  TextButton(
                    onPressed: _resendOTP,
                    child: RichText(
                      text: TextSpan(
                        text: 'Didn\'t receive code? ',
                        style: TextStyle(color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Resend',
                            style: TextStyle(
                              color: _isTimerRunning ? Colors.white.withOpacity(0.5) : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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

  void _resendOTP() {
    if (!_isTimerRunning) {
      setState(() {
        _countdownTime = 119; // Reset countdown time
      });
      _startCountdown();
      // Add logic to resend OTP
      print('OTP resent');
    }
  }
}
