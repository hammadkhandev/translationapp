import 'package:flutter/material.dart';
import 'package:norsk_tolk/views/common/home_widget.dart';
import '../../models/language_data.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/styles.dart';

class ChooseLanguage extends StatefulWidget {
  final Function(String) onLanguageSelected;
  final int selectedLanguageId;

  const ChooseLanguage({
    Key? key,
    required this.onLanguageSelected,
    required this.selectedLanguageId,
  }) : super(key: key);

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  late int selectedLanguageId;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedLanguageId = widget.selectedLanguageId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choose Language',
          style: labelSmall(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColorLight,
          ),
        ),
        centerTitle: true,
      ),
      body: HomeWidget(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColorTextField,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: labelSmall(context).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: hintTextColor,
                    ),
                    filled: true,
                    fillColor: backgroundColorTextField,
                    // prefixIcon: Icon(Icons.search, color: hintTextColor),
                    prefixIcon: Padding(
                      padding:  EdgeInsetsDirectional.only(start: 16,end: 4),
                      child:  Image.asset(Images.search , width: 20,height: 20,color: hintTextColor)
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    border: InputBorder.none,
                    // focusedBorder: InputBorder.none,
                    // enabledBorder: InputBorder.none,
                    // errorBorder: InputBorder.none,
                    // disabledBorder: InputBorder.none,
        
                    contentPadding: EdgeInsets.symmetric( vertical: 8),
                  ),
                ),
              ),
            ),
        
            // Free languages
            _buildSection('Free', freeLanguages, false),
        
            // Premium languages
            // _buildSection('Premium', premiumLanguages, true),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Language> languages, bool isPremium) {
    final filteredLanguages = languages.where((lang) {
      return lang.name.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredLanguages.isEmpty) return const SizedBox();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: labelSmall(context).copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColorLight,
              ),
            ),
          ),
          const SizedBox(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLanguages.length,
              itemBuilder: (context, index) {
                final language = filteredLanguages[index];
                final isSelected = language.id == selectedLanguageId;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: dividerColorLight),
                    ),
                    child: ListTile(
                      title: Text(
                        language.name,
                        style: labelSmall(context).copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColorLight,
                        ),
                      ),
                      trailing: isPremium
                          ? Image.asset(Images.crown)
                          : Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? primaryColor :dividerColorLight,
                            width: 2,
                          ),
                          color: isSelected ? primaryColor : borderColorLight,
                        ),
                        child: isSelected
                            ? const Icon(Icons.circle, color: Colors.white, size: 15)
                            : const Icon(Icons.circle, color: borderColorLight, size: 20),
                      ),
                      onTap: () {
                        if (isPremium) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Premium language - Upgrade required'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          selectedLanguageId = language.id as int;
                        });
                        widget.onLanguageSelected(language.name);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

