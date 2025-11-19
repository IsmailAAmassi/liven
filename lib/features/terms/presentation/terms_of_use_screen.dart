import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  static const routePath = '/terms';
  static const routeName = 'terms';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Use')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text(
            'By using Liven you agree to respect our community guidelines, '
            'protect your personal information, and refrain from sharing '
            'sensitive data in public spaces. These terms are placeholders '
            'for the legal copy that will be provided later.',
          ),
          SizedBox(height: 24),
          Text(
            'Your privacy and security are important to us. We keep all data on '
            'your device for this demo build and never send it to an external backend.',
          ),
        ],
      ),
    );
  }
}
