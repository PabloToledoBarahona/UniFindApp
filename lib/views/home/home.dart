import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unifind/views/lost_item/lost_item_form_controller.dart';
import 'package:unifind/views/lost_item/lost_item_page.dart';
import '../../models/lost_item_model.dart';
import '../../widgets/lost_item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LostItem> items = [];
  final LostItemFormController _repository = LostItemFormController();

  String? currentUserEmail; // Esto ahora es nullable para manejar casos donde el usuario no esté autenticado.

  @override
  void initState() {
    super.initState();
    _loadLostItems();
    _getCurrentUserEmail(); // Obtener el email del usuario actual al iniciar
  }

  void _getCurrentUserEmail() {
    // Establece el email del usuario actual de Firebase
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email;
      });
    }
  }

  Stream<List<LostItem>> _loadLostItems() {
    return _repository.fetchLostItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LostItemForm()));
        },
        backgroundColor: const Color.fromRGBO(129, 40, 75, 1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: const Text('Objetos Reportados'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<LostItem>>(
        stream: _loadLostItems(),
        builder: (BuildContext context, AsyncSnapshot<List<LostItem>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay objetos perdidos reportados aún.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final item = snapshot.data![index];
              return LostItemCard(
                item: item,
                onTap: () {
                  // Aquí puedes manejar la acción al tocar la tarjeta, como navegar a una pantalla de detalles
                },
                currentUserEmail: currentUserEmail ?? '', // Pasas el correo electrónico del usuario actual, o una cadena vacía si es nulo.
              );
            },
          );
        },
      ),
    );
  }
}
