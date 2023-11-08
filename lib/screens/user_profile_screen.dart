import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  final ImagePicker _picker = ImagePicker();

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/register'); 
  }

  Future<void> _selectImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Perfil de Usuario')),
        body: Center(child: Text('No hay un usuario autenticado. Inicie sesión.')),
      );
    }

    final firestore = FirebaseFirestore.instance;

    Future<String> getUsername(String uid) async {
      try {
        var userData = await firestore.collection('users').doc(uid).get();
        return userData.data()?['username'] ?? 'Nombre de usuario no disponible';
      } catch (e) {
        return 'Error al obtener el nombre de usuario';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
        actions: [
          GestureDetector(
            onTap: () {
              _selectImageFromGallery();
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? 'https://via.placeholder.com/150'),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder(
        future: getUsername(user.uid),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          String username = snapshot.data ?? 'No disponible';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Nombre de usuario: $username', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Correo electrónico: ${user.email ?? 'Correo no disponible'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => signOut(context),
                  child: Text('Cerrar sesión'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
