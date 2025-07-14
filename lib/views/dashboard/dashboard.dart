import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:norsk_tolk/utils/images.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          Image.asset(
            Images.map,
            height: 1.sh,
            width: 1.sw,
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.only(left: 25.sp, right: 25.sp, top: 25.sp),
                height: 80.sp,
                width: 1.sw,
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: [
                    Image.asset(
                      Images.logo,
                      height: 50.sp,
                      width: 50.sp,
                    ),
                    Spacer(),
                    Icon(
                      Icons.settings,
                    ),
                  ],
                ),
              )),
          Positioned(
            bottom: 120.sp,
            child: LanguageSwapSelector(),
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey, // Unselected item color
        selectedLabelStyle:
            Theme.of(context).textTheme.labelLarge?.copyWith(inherit: true, color: Theme.of(context).primaryColor),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(inherit: true),

        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.voice,
              height: 20.sp,
              width: 20.sp,
              color: _currentIndex == 0 ? Theme.of(context).colorScheme.secondary : Colors.grey,
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
              color: _currentIndex == 1 ? Theme.of(context).colorScheme.secondary : Colors.grey,
            ),
            label: 'Camera',
          ),
        ],
      ),
    );
  }
}

class LanguageSwapSelector extends StatefulWidget {
  const LanguageSwapSelector({super.key});

  @override
  _LanguageSwapSelectorState createState() => _LanguageSwapSelectorState();
}

class _LanguageSwapSelectorState extends State<LanguageSwapSelector> {
  String sourceLang = 'English USA';
  String targetLang = 'French';

  final List<String> languages = [
    'English USA',
    'French',
    'Urdu',
    'German',
    'Spanish',
    // Add more...
  ];

  void _swapLanguages() {
    setState(() {
      final temp = sourceLang;
      sourceLang = targetLang;
      targetLang = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: sourceLang,
            underline: SizedBox(),
            items: languages
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    ))
                .toList(),
            onChanged: (val) => setState(() => sourceLang = val!),
          ),
          IconButton(
            icon: Icon(Icons.compare_arrows, size: 32, color: Colors.blue),
            onPressed: _swapLanguages,
            tooltip: 'Swap Languages',
          ),
          DropdownButton<String>(
            value: targetLang,
            underline: SizedBox(),
            items: languages
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    ))
                .toList(),
            onChanged: (val) => setState(() => targetLang = val!),
          ),
        ],
      ),
    );
  }
}
