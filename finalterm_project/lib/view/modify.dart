// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:finalterm_project/model/product.dart';
import 'package:finalterm_project/model/product_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ModifyPage extends StatefulWidget {
  final DocumentSnapshot? productData;

  const ModifyPage({Key? key, this.productData}) : super(key: key);

  @override
  State<ModifyPage> createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  ProductModel? product;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (product == null) {
      product = ModalRoute.of(context)!.settings.arguments as ProductModel;
      _nameController.text = product!.name;
      _priceController.text = product!.price.toString();
      _descriptionController.text = product!.description;
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

    Future<void> _modifyProduct() async {
    final String imageUrl = await _uploadImage();

    product!
      ..name = _nameController.text
      ..price = int.parse(_priceController.text)
      ..description = _descriptionController.text
      ..image = imageUrl;

    Provider.of<ProductRepository>(context, listen: false).updateProduct(product!);

    Navigator.pop(context);
  }


  Future<String> _uploadImage() async {
    if (_image == null) {
      return product!.image!;
    }

    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('products')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      await ref.putFile(
        File(_image!.path),
      );
    } catch (e) {
      print('Failed to upload image: $e');
    }

    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit'),
          centerTitle: true,
          backgroundColor: Colors.grey.shade600,
          leadingWidth: 70,
          leading: IconButton(
            icon: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _modifyProduct();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             _image != null
                ? Image.file(
                    File(_image!.path),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                : Image.network(
                    product!.image!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      semanticLabel: 'pickImage',
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _pickImage();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                    ),
                    TextField(
                      controller: _priceController,
                    ),
                    TextField(
                      controller: _descriptionController,
                      maxLines: null,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
