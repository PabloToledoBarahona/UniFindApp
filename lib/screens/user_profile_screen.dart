import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Perfil de Usuario')),
        body: Center(child: Text('No hay un usuario autenticado. Inicie sesión.')),
      );
    }

    // Acceso a la instancia de Firestore
    final firestore = FirebaseFirestore.instance;

    // Crear una función para obtener el nombre de usuario desde Firestore
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
    CircleAvatar(
      backgroundImage: NetworkImage(user.photoURL ?? 'https://via.placeholder.com/150'),
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
                // Botón de cierre de sesión...
              ],
            ),
          );
        },
      ),
    );
  }
}
