import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:norsk_tolk/utils/images.dart';
import 'package:norsk_tolk/utils/styles.dart';
import 'package:norsk_tolk/views/dashboard/dashboard.dart';
import 'package:norsk_tolk/views/login/components/button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
          SizedBox(
            height: 50.sp,
          ),
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
                    )),
                Positioned(
                    top: 10,
                    bottom: 0,
                    child: Image.asset(
                      Images.persons,
                      height: 410.sp,
                      width: 1.sw,
                      fit: BoxFit.scaleDown,
                    )),
                Positioned(
                    bottom: 0,
                    child: Image.asset(
                      Images.lng,
                      height: 288.sp,
                      width: 290.sp,
                      fit: BoxFit.scaleDown,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 15.sp,
          ),
          Text('Login to Continue',
              style: titleLarge(context).copyWith(
                fontWeight: FontWeight.bold,
              )),
          SizedBox(
            height: 10,
          ),
          Text('Join 5M+ users trusting us.', style: bodySmall(context).copyWith()),
          SizedBox(
            height: 25.sp,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: Column(
              children: [
                Button(
                  width: 300.sp,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Dashboard();
                    }));
                  },
                  icon: Images.google,
                  text: 'Continue with Google',
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Button(
                  width: 300.sp,
                  onPressed: () {},
                  icon: Images.apple,
                  text: 'Continue with Apple ',
                ),
              ],
            ),
          )
                ],
              ),
        ));
  }
}
