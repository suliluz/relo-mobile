import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Japanese',
    'Korean',
    'Mandarin',
    'Portuguese',
    'Russian',
    'Vietnamese',
  ];

  final List<String> _locales = [
    'en',
    'es',
    'fr',
    'de',
    'it',
    'ja',
    'ko',
    'zh',
    'pt',
    'ru',
    'vi',
  ];

  String _selectedLanguage = 'English';
  String _selectedLocale = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A label and dropdown for Language
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                    child: Text("Language", style: TextStyle(fontSize: 16),),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedLanguage,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black87),
                    underline: Container(
                      height: 2,
                      color: Colors.black87,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                    items: _languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            // A label and dropdown for Locale
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  child: Text("Locale", style: TextStyle(fontSize: 16),),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedLocale,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black87),
                    underline: Container(
                      height: 2,
                      color: Colors.black87,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocale = newValue!;
                      });
                    },
                    items: _locales.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            // Save button
            ElevatedButton(
              onPressed: () {

              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
