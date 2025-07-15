import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:norsk_tolk/service/google_sign_in_service.dart';
import 'package:norsk_tolk/utils/images.dart';
import 'package:norsk_tolk/utils/styles.dart';
import 'package:norsk_tolk/views/dashboard/main_dashboard.dart';
import 'package:norsk_tolk/views/login/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GoogleAuthService _authService = GoogleAuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainDashboard()),
              (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildLoginContent(context),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50.sp),
          SizedBox(
            height: 500.sp,
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 150,
                  right: 0,
                  child: Image.asset(
                    Images.bn,
                    height: 100.sp,
                    width: 100.sw,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Positioned(
                  top: 10,
                  bottom: 0,
                  child: Image.asset(
                    Images.persons,
                    height: 410.sp,
                    width: 1.sw,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Image.asset(
                    Images.lng,
                    height: 288.sp,
                    width: 290.sp,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.sp),
          Text(
            'Login to Continue',
            style: titleLarge(context).copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Join 5M+ users trusting us.',
            style: bodySmall(context),
          ),
          SizedBox(height: 25.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: Column(
              children: [
                Button(
                  width: 300.sp,
                  onPressed: () {
                    if (kReleaseMode) {
                      _handleGoogleSignIn();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MainDashboard()),
                      );
                    }
                  },
                  icon: Images.google,
                  text: 'Continue with Google',
                ),
                SizedBox(height: 10.sp),
                Button(
                  width: 300.sp,
                  onPressed: () {},
                  icon: Images.apple,
                  text: 'Continue with Apple',
                ),
              ],
            ),
          ),
          SizedBox(height: 20.sp),
        ],
      ),
    );
  }
}
