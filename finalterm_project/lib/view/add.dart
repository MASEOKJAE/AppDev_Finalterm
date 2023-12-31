// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:finalterm_project/model/product.dart';
import 'package:finalterm_project/model/product_repository.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddState();
}

class _AddState extends State<AddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  String get userId => UserRepository.user!.uid;

  Future<void> _addProduct() async {
    setState(() {
      _isLoading = true;
    });

    final String imageUrl = await _uploadImage();
    print('가져온 이미지 주소!! ->  ${imageUrl}');

    ProductModel newProduct = ProductModel.fromJson({
      'userId': userId,
      'name': _nameController.text,
      'price': int.parse(_priceController.text),
      'Description': _descriptController.text,
      'image': imageUrl,
      'saveTime': Timestamp.now(),
      'likedUid': [],
    });

    Provider.of<ProductRepository>(context, listen: false)
        .addProduct(newProduct);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  Future<String> _uploadImage() async {
    if (_image == null) {
      return 'http://handong.edu/site/handong/res/img/logo.png';
    }

    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('products')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    print('이미지 가지러 왔습니다!!\n');
    // await ref.putFile(
    //   File(_image!.path),
    // );
    try {
      await ref.putFile(
        File(_image!.path),
      );
    } catch (e) {
      print('Failed to upload image: $e');
      // You can also show a dialog or a snackbar with the error message.
    }

    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
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
        centerTitle: true,
        backgroundColor: Colors.grey.shade600,
        actions: <Widget>[
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: CircularProgressIndicator(),
            )
          else
            IconButton(
              icon: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _addProduct();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    'http://handong.edu/site/handong/res/img/logo.png',
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                  TextField(
                    controller: _descriptController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    keyboardType: TextInputType.number,
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
