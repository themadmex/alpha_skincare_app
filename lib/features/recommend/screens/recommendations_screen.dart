import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecommendationsScreen extends StatelessWidget { const RecommendationsScreen({Key? key}) : super(key: key);

@override Widget build(BuildContext context) { final uid = FirebaseAuth.instance.currentUser?.uid; if (uid == null) { return const Scaffold( body: Center(child: Text('User not logged in')), ); }
final docStream = FirebaseFirestore.instance
    .collection('recommendations')
    .doc(uid)
    .snapshots();

return Scaffold(
  appBar: AppBar(title: const Text('Recommendations')),
  body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: docStream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const Center(child: Text('No recommendations found'));
      }
      final data = snapshot.data!.data()!;
      final morning = List<String>.from(data['morning'] as List<dynamic>);
      final evening = List<String>.from(data['evening'] as List<dynamic>);
      final products = List<Map<String, dynamic>>.from(data['products'] as List<dynamic>);

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Morning Routine', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...morning.map((step) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(step),
            )),
            const SizedBox(height: 16),
            Text('Evening Routine', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...evening.map((step) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(step),
            )),
            const SizedBox(height: 16),
            Text('Products', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...products.map((p) => ListTile(
              leading: p['imageUrl'] != null
                  ? Image.network(p['imageUrl'] as String, width: 40, height: 40)
                  : const Icon(Icons.shopping_bag_outlined),
              title: Text(p['name'] as String),
              subtitle: p['description'] != null ? Text(p['description'] as String) : null,
            )),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Bookmark Routine'),
              ),
            ),
          ],
        ),
      );
    },
  ),
);}}
