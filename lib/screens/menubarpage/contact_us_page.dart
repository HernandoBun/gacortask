import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

// untuk send email menggunakan API dari emailjs
Future sendEmail() async {
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId = "service_vo8qm6o";
  const templateId = "template_fzskcfl";
  const userId = "GyvhuxDO1QN5oaXoe";

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": userId,
        "template_params": {
          "user_name": nameController.text,
          "subject": subjectController.text,
          "message": messageController.text,
          "user_email": emailController.text,
        }
      }),
    );

    return response.statusCode;
  } catch (error) {
    return 500;
  }
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            Constants.titleContact,
            style: TextStyle(
              fontFamily: Constants.fontOpenSansRegular,
              color: themeProvider.secondaryColor,
            ),
          ),
          backgroundColor: themeProvider.primaryColor,
          foregroundColor: themeProvider.secondaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle,
                        color: themeProvider.primaryColor),
                    hintText: Constants.titleName,
                    labelText: Constants.titleName,
                  ),
                ),
                SizedBox(
                  height: getScreenHeight(25.0),
                ),
                TextFormField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.subject_rounded,
                      color: themeProvider.primaryColor,
                    ),
                    hintText: Constants.labelHint,
                    labelText: Constants.labelHint,
                  ),
                ),
                SizedBox(
                  height: getScreenHeight(25.0),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email, color: themeProvider.primaryColor),
                    hintText: Constants.titleEmail,
                    labelText: Constants.titleEmail,
                  ),
                ),
                SizedBox(
                  height: getScreenHeight(25.0),
                ),
                TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    icon:
                        Icon(Icons.message, color: themeProvider.primaryColor),
                    hintText: Constants.labelHint1,
                    labelText: Constants.labelHint1,
                  ),
                ),
                SizedBox(
                  height: getScreenHeight(30.0),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(themeProvider.primaryColor)),
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        subjectController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        messageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            Constants.textSnack,
                            style: TextStyle(color: themeProvider.primaryColor),
                          ),
                        ),
                      );
                      return;
                    }

                    final statusCode = await sendEmail();

                    if (statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(Constants.textSnack1),
                        ),
                      );
                      nameController.clear();
                      subjectController.clear();
                      emailController.clear();
                      messageController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Failed to send email. Error code: $statusCode"),
                        ),
                      );
                    }
                  },
                  child: Text(
                    Constants.textSendEmail,
                    style: TextStyle(
                      color: themeProvider.secondaryColor,
                      fontSize: getScreenWidth(20.0),
                      fontFamily: Constants.fontOpenSansRegular,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
