import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final doc = await _firestore.collection('profiles').doc(userId).get();
    return doc.data();
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) {
    return _firestore.collection('profiles').doc(userId).set(data);
  }
}
