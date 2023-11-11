import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  DocumentSnapshot? productData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (productData == null) {
      productData =
          ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
      _nameController.text = productData!['name'];
      _priceController.text = productData!['price'];
      _descriptionController.text = productData!['Description'];
    }
  }

  Future<void> _modifyProduct() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productData!.id)
        .update({
      'name': _nameController.text,
      'price': _priceController.text,
      'Description': _descriptionController.text,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
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
              Image.network(
                productData!['image'],
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
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
