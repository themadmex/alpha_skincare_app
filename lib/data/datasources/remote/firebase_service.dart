// lib/data/datasources/remote/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth Methods
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Firestore Methods
  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> saveScanResult(String userId, Map<String, dynamic> scanData) async {
    try {
      await _firestore.collection('scans').add({
        'userId': userId,
        'scanDate': FieldValue.serverTimestamp(),
        ...scanData,
      });
    } catch (e) {
      throw Exception('Failed to save scan result: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getUserScans(String userId) {
    return _firestore
        .collection('scans')
        .where('userId', isEqualTo: userId)
        .orderBy('scanDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList());
  }

  // Storage Methods
  Future<String> uploadScanImage(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('scans/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}