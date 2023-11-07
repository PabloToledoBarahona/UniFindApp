import 'package:flutter/material.dart';
import 'lost_item_form_controller.dart';
import 'package:image_picker/image_picker.dart';

class LostItemForm extends StatefulWidget {
  const LostItemForm({Key? key}) : super(key: key);

  @override
  State<LostItemForm> createState() => _LostItemFormState();
}

class _LostItemFormState extends State<LostItemForm> {
  final LostItemFormController _controller = LostItemFormController();
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _location = '';
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objetos Perdidos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: const Text('Nombre del objeto'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFECDFE4),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: _controller.validateItemName,
                        onSaved: (value) => _title = value!,
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: const Text('Número de teléfono'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFECDFE4),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: _controller.validatePhoneNumber,
                        onSaved: (value) => _phoneNumber = value!,
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: const Text('Descripción'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFECDFE4),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: _controller.validateItemDescription,
                        onSaved: (value) => _description = value!,
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: const Text('Lugar'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFECDFE4),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'El lugar es obligatorio' : null,
                        onSaved: (value) => _location = value!,
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _controller.getImage(ImageSource.camera);
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromRGBO(129, 40, 75, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Icon(Icons.camera_alt),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                await _controller.getImage(ImageSource.gallery);
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color.fromRGBO(129, 40, 75, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Icon(Icons.photo_library),
                            ),
                          ),
                        ],
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final imageUrl =
                                  await _controller.uploadImageToFirebase();
                              await _controller.saveLostItemToFirestore(
                                  title: _title,
                                  description: _description,
                                  location: _location,
                                  imageUrl: imageUrl,
                                  phoneNumber: _phoneNumber);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Objeto Reportado'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromRGBO(129, 40, 75, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'REPORTAR OBJETO',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
