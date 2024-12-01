import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final List<Map<String, String>> faqData = [
    {
      Constants.faqQuestion: Constants.faqQuestion1,
      Constants.faqAnswer: Constants.faqAnswer1
    },
    {
      Constants.faqQuestion: Constants.faqQuestion2,
      Constants.faqAnswer: Constants.faqAnswer2
    },
    {
      Constants.faqQuestion: Constants.faqQuestion3,
      Constants.faqAnswer: Constants.faqAnswer3
    },
    {
      Constants.faqQuestion: Constants.faqQuestion4,
      Constants.faqAnswer: Constants.faqAnswer4
    },
    {
      Constants.faqQuestion: Constants.faqQuestion5,
      Constants.faqAnswer: Constants.faqAnswer5
    },
    {
      Constants.faqQuestion: Constants.faqQuestion6,
      Constants.faqAnswer: Constants.faqAnswer6
    },
    {
      Constants.faqQuestion: Constants.faqQuestion7,
      Constants.faqAnswer: Constants.faqAnswer7
    },
    {
      Constants.faqQuestion: Constants.faqQuestion8,
      Constants.faqAnswer: Constants.faqAnswer8
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(Constants.titleFaq),
          backgroundColor: themeProvider.primaryColor,
          foregroundColor: themeProvider.secondaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: List.generate(
                faqData.length,
                (index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Constants.border),
                    ),
                    elevation: 5.0,
                    child: ExpansionTile(
                      title: Text(
                        faqData[index]['question']!,
                        style: TextStyle(
                          fontFamily: Constants.fontOpenSansRegular,
                          fontSize: getScreenWidth(16.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            faqData[index]['answer']!,
                            style: TextStyle(
                              fontFamily: Constants.fontOpenSansRegular,
                              fontSize: getScreenWidth(16.0),
                              color: Constants.colorBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
