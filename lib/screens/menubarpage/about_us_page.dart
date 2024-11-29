import 'package:flutter/material.dart';
 
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: double.infinity,
                  height: 200.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/AboutUs.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Introducing Our Team!',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'We are a team of passionate developers and designers dedicated to building high-quality applications that make your life easier. Our goal is to provide innovative solutions that are user-friendly and efficient.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Our Team:',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20.0),
              teamMember('John Doe', 'CEO & Lead Developer', 'assets/images/john_doe.jpg'),
              const SizedBox(height: 10.0),
              teamMember('Jane Smith', 'Product Manager', 'assets/images/jane_smith.jpg'),
              const SizedBox(height: 10.0),
              teamMember('Michael Brown', 'UX/UI Designer', 'assets/images/michael_brown.jpg'),
              const SizedBox(height: 10.0),
              teamMember('Alice White', 'Backend Developer', 'assets/images/alice_white.jpg'),
              const SizedBox(height: 10.0),
              teamMember('David Black', 'Marketing Specialist', 'assets/images/david_black.jpg'),
              const SizedBox(height: 10.0),
              teamMember('Sophia Green', 'Quality Assurance', 'assets/images/sophia_green.jpg'),
              const SizedBox(height: 20.0),
              const Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Email: support@ourapp.com',
                style: TextStyle(fontSize: 16.0),
              ),
              const Text(
                'Phone: +123 456 7890',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Thank you for using our application! We are constantly working to improve and provide better services to our users.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget teamMember(String name, String role, String imageAsset) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage(imageAsset),
        ),
        const SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Text(
              role,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
 