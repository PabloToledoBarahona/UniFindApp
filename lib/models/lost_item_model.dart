import 'package:cloud_firestore/cloud_firestore.dart';

class LostItem {
  final String id;
  final String name;
  final String description;
  final String location;
  final String? imageUrl;
  final DateTime? timestamp;
  final String userId;
  final String userEmail;
  final String phone;

  LostItem({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.imageUrl,
    this.timestamp,
    required this.userId,
    required this.userEmail,
    required this.phone
  });

  factory LostItem.fromDocument(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>? ?? {};
  return LostItem(
    id: doc.id,
    name: data['name'] as String? ?? 'Nombre desconocido',
    description: data['description'] as String? ?? 'Descripción no disponible',
    location: data['location'] as String? ?? 'Ubicación no disponible',
    imageUrl: data['imageUrl'] as String?,
    timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    userId: data['userId'] as String? ?? 'Usuario desconocido',
    userEmail: data['userEmail'] as String? ?? 'Email no disponible',
    phone: data['phone'] as String? ?? 'Teléfono no disponible',
  );
}

}
