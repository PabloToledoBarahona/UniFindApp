import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lost_item_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LostItemDetailsPage extends StatelessWidget {
  final LostItem item;
  final String currentUserEmail; // Para verificar si el usuario actual es el creador del objeto

  LostItemDetailsPage({
    Key? key,
    required this.item,
    required this.currentUserEmail,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  String _formatPhoneNumber(String? number) {
    final String phoneNumber = number ?? "+59177061535"; // Un número de teléfono por defecto
    return phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  Future<void> _contactViaWhatsApp() async {
    final whatsappUrl = "https://wa.me/${_formatPhoneNumber(item.phone)}";
    await _launchUrl(whatsappUrl);
  }

  Future<void> _makePhoneCall() async {
    final phoneUrl = "tel:${_formatPhoneNumber(item.phone)}";
    await _launchUrl(phoneUrl);
  }

  // Función para eliminar un objeto
  Future<void> _deleteItem(BuildContext context) async {
    try {
      // Obtén una instancia de Firestore
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance
          .collection('lost_items') // Asume que usas una colección llamada 'lostItems'
          .doc(item.id) // Utiliza el ID del objeto para localizar el documento
          .delete(); // Elimina el documento

      // Navegar de vuelta a la lista de objetos perdidos y mostrar mensaje
      Navigator.of(context).pop(); // Regresa a la pantalla anterior
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Objeto eliminado con éxito'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // Añade el logueo del error
      print(e); // Esto te ayudará a entender qué salió mal.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el objeto: $e'), // Muestra el error en el SnackBar.
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Objeto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (item.imageUrl != null)
              Image.network(
                item.imageUrl!,
                height: 250.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16.0),
            Text(
              item.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              item.description,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8.0),
                Text(item.location),
              ],
            ),
            if (item.timestamp != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 8.0),
                    Text(
                      '${item.timestamp!.day}/${item.timestamp!.month}/${item.timestamp!.year} ${item.timestamp!.hour}:${item.timestamp!.minute}',
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              "Contacto: ${item.userEmail}",
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.message),
                  label: Text('WhatsApp'),
                  onPressed: _contactViaWhatsApp,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.call),
                  label: Text('Llamar'),
                  onPressed: _makePhoneCall,
                ),
              ],
            ),
            if (currentUserEmail == item.userEmail)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center( // Centro el botón en la pantalla
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.find_in_page),
                    label: Text('Marcar objeto como encontrado'),
                    onPressed: () => _deleteItem(context), // Cambia la función llamada aquí
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
