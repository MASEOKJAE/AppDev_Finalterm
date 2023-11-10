import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<AddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
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

  Future<void> _addProduct() async {
    setState(() {
      _isLoading = true;
    });

    final String imageUrl = await _uploadImage();

    DocumentReference ref = await FirebaseFirestore.instance.collection('products').add({
      'userId': user?.uid,
      'name': _nameController.text,
      'price': _priceController.text,
      'Description': _descriptController.text,
      'image': imageUrl,
      'saveTime': FieldValue.serverTimestamp(),
      'modifyTime': FieldValue.serverTimestamp(),
      'like': 0,
    });

    String docId = ref.id;

    await FirebaseFirestore.instance.collection('products').doc(docId).update({
      'pid': docId,
    });

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

    await ref.putFile(
      File(_image!.path),
    );

    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
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
            if (_image != null)
              Image.file(File(_image!.path))
            else
              Image.network('http://handong.edu/site/handong/res/img/logo.png'),
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
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
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
