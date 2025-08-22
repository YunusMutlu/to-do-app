import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final bool isDarkMode;
  final void Function(bool)? onThemeChanged;
  const Settings({required this.isDarkMode, this.onThemeChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          Card(
            surfaceTintColor: Colors.black12,
            shadowColor: Colors.black87,
            child: ListTile(
              enabled: true,
              title: Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  if (onThemeChanged != null) {
                    onThemeChanged!(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
