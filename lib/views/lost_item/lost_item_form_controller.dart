import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/lost_item_model.dart';

class LostItemFormController {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final _firestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  final CollectionReference collection = FirebaseFirestore.instance.collection('lost_items');

  File? get image => _image;

  Future<File?> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      return _image;
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<String?> uploadImageToFirebase() async {
    if (_image != null) {
      String email = _auth.currentUser!.email!;
      email = email.replaceAll(".", "_");
      final ref = _firebaseStorage
          .ref()
          .child(email)
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(_image!);
      return await ref.getDownloadURL();
    } else {
      return null;
    }
  }

  Future<void> saveLostItemToFirestore(
      {required String title,
      required String description,
      required String location,
      String? imageUrl,
      required String phoneNumber}) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('lost_items').add({
      'name': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': uid,
      'userEmail': _auth.currentUser!.email!,
      'phoneNumber': phoneNumber,
    });
  }

  String? validateItemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingrese el nombre del objeto';
    }
    return null;
  }

  String? validateItemDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingrese una descripción';
    }
    return null;
  }

  Stream<List<LostItem>> fetchLostItems() {
    return collection.orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => LostItem.fromDocument(doc)).toList();
    });
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingrese su número de teléfono';
    }
    return null;
  }
}
