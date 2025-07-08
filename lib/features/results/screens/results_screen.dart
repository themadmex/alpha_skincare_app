import 'dart:io';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final File? imageFile = ModalRoute.of(context)?.settings.extra as File?;
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (imageFile != null)
              Image.file(imageFile, height: 200),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(title: Text('Skin Type'), trailing: Text('Combination')),
                  ListTile(title: Text('Hydration'), trailing: Text('65%')),
                  ListTile(title: Text('Sun Damage'), trailing: Text('Low')),
                  ListTile(title: Text('Acne'), trailing: Text('Moderate')),
                  ListTile(title: Text('Pores'), trailing: Text('Visible')),
                  ListTile(title: Text('Redness'), trailing: Text('8%')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}