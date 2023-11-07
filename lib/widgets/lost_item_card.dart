import 'package:flutter/material.dart';
import 'package:unifind/widgets/lost_items_details.dart';
import '../models/lost_item_model.dart';

class LostItemCard extends StatelessWidget {
  final LostItem item;
  final VoidCallback onTap;
  final String currentUserEmail; // Agregando variable para el email del usuario

  // Requerimos que se pase el email del usuario actual al crear el LostItemCard
  const LostItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.currentUserEmail, // Hacer el email del usuario un parámetro requerido
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LostItemDetailsPage(
              item: item,
              currentUserEmail: currentUserEmail, // Pasar el email del usuario como argumento
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 50, right: 50, bottom: 30),
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: SizedBox(
                  height: 250.0,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8.0),
                    ),
                    child: item.imageUrl != null
                        ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported, size: 250.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Objeto Encontrado',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class LostItemListPage extends StatelessWidget {
  final List<LostItem> items;
  final String currentUserEmail;

  LostItemListPage({Key? key, required this.items, required this.currentUserEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objetos Perdidos'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Creas un LostItemCard para cada LostItem en la lista
          return LostItemCard(
            item: items[index],
            onTap: () {
              // Acción cuando se toca la tarjeta, por ejemplo abrir detalles
            },
            currentUserEmail: currentUserEmail, // Pasas el email del usuario actual
          );
        },
      ),
    );
  }
}