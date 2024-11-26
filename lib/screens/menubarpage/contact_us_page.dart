import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us Form"),
        backgroundColor: Constants.colorBlueHer,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  hintText: 'Name',
                  labelText: 'Name',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.subject_rounded),
                  hintText: 'Subject',
                  labelText: 'Subject',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Email',
                  labelText: 'Email',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.message),
                  hintText: 'Message',
                  labelText: 'Message',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      subjectController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      messageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill in all fields")),
                    );
                    return;
                  }

                  final statusCode = await sendEmail();

                  if (statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email sent successfully"),
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
                child: const Text(
                  "Send Email",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
