// pages/edit_page.dart
import 'package:flutter/material.dart';
import '../models/phones.dart';
import '../services/api_services.dart';

class EditPage extends StatefulWidget {
  static const String routeName = '/edit';
  final Phone phone;

  const EditPage({Key? key, required this.phone}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;
  late TextEditingController _specificationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.phone.name);
    _brandController = TextEditingController(text: widget.phone.brand);
    _priceController = TextEditingController(text: widget.phone.price.toString());
    _imageController = TextEditingController(text: widget.phone.img_url);
    _specificationController = TextEditingController(text: widget.phone.specification);
  
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedPhone = Phone(
        id: widget.phone.id,
        name: _nameController.text,
        brand: _brandController.text,
        price: _priceController.text,
        img_url: _imageController.text,
        specification: _specificationController.text,
      );

      try {
        await ApiService.updatePhone(int.parse(widget.phone.id), updatedPhone);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone berhasil diupdate')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'brand'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _specificationController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Update Phone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
