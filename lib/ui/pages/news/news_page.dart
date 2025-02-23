import 'package:buai/ui/widgets/app_buttons.dart';
import 'package:buai/ui/widgets/app_texts.dart';
import 'package:buai/utils/colors.dart';
import 'package:buai/utils/constants.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String newsLanguage = 'English';
  List<String> languages = AppConstants.languages.map((l) => l.name).toList();

  getLanguageCode(String language) {
    return AppConstants.languages.firstWhere((l) => l.name == language).code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButtons.backButton(onPressed: () {}),
                  AppButtons.dropdownButton(
                    onPressed: (String lang) {
                      setState(() => newsLanguage = lang);
                    },
                    context: context,
                    items: languages,
                    activeItem: newsLanguage,
                    color: AppColors.primaryBlue,
                  ),
                ],
              ),
              SizedBox(height: 20),
              AppTexts.sectionTitle(
                title: 'Breaking News',
                subtitle: 'Top headlines from around the world',
                context: context,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
