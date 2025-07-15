import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/images.dart';
import 'camera_translation_screen.dart';
import 'voice_screen.dart';
import 'home_screen.dart'; // renamed from Dashboard

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 1; // Default to home

  final List<Widget> _screens = const [
    VoiceScreen(),
    HomeScreen(), // Previously Dashboard
    // CameraScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index == 2) {
            // Go to CameraScreen without bottom bar
            final cameras = await availableCameras();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraTranslationScreen(cameras: cameras,)),
            ).then((_) {
              setState(() => _currentIndex );
            });
          } else {
            setState(() => _currentIndex = index);
          }
        },

        // onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).primaryColor,
        selectedLabelStyle: Theme.of(context).textTheme.labelLarge,
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.voice,
              height: 20.sp,
              width: 20.sp,
              color: _currentIndex == 0
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey,
            ),
            label: 'Voice',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(10.sp),
              height: 55.sp,
              width: 55.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Image.asset(
                Images.tr,
                fit: BoxFit.scaleDown,
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.camara,
              height: 20.sp,
              width: 20.sp,
              color: _currentIndex == 2
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey,
            ),
            label: 'Camera',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.mic),
          //   label: 'Voice',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.translate),
          //   label: 'Home',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.camera_alt),
          //   label: 'Camera',
          // ),
        ],
      ),
    );
  }
}
