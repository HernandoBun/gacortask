import 'package:flutter/material.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Theme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: const Text('Theme 1: Blue & White'),
              trailing: IconButton(
                icon: const Icon(Icons.palette),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changeTheme(1);
                },
              ),
            ),
            ListTile(
              title: const Text('Theme 2: Red & Purple'),
              trailing: ElevatedButton(
                child: const Icon(Icons.color_lens_rounded),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changeTheme(2);
                },
              ),
            ),
            ListTile(
              title: const Text('Theme 3: Green & Orange'),
              trailing: IconButton(
                icon: const Icon(Icons.palette),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changeTheme(3);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}