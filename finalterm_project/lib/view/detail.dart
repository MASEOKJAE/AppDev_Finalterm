// ignore_for_file: use_build_context_synchronously

import 'package:finalterm_project/model/product.dart';
import 'package:finalterm_project/model/product_repository.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ProductModel? _product;

  String get userId => UserRepository.user!.uid;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _product = ModalRoute.of(context)!.settings.arguments as ProductModel;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Consumer<ProductRepository>(
      builder: (context, provider, child) {
        UserRepository userProvider =
            Provider.of<UserRepository>(context, listen: false);
        ProductModel product = provider.getProduct(_product!.id!);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail'),
            centerTitle: true,
            backgroundColor: Colors.grey.shade600,
            actions: [
              if (userId == product.userId) // 만약 현재 사용자가 게시물의 작성자인 경우
                IconButton(
                  icon: const Icon(Icons.create),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/modify',
                      arguments: product,
                    );
                  },
                ),
              if (userId == product.userId) // 만약 현재 사용자가 게시물의 작성자인 경우
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    provider.deleteProduct(product.id!);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  // for longer descriptions
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        product.image!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Color.fromARGB(255, 6, 94, 194),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.thumb_up,
                                        semanticLabel: 'like',
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        ProductRepository repository =
                                            Provider.of<ProductRepository>(
                                                context,
                                                listen: false);
                                        bool succeeded =
                                            repository.like(product);
                                        await repository
                                            .updateOneToDatabase(product);
                                        setState(() {});

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              succeeded
                                                  ? 'I LIKE IT !'
                                                  : 'You can only do it once !!',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${product.likedUids.length}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),

                            Text(
                              '\$ ${product.price}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 22, 114, 220),
                              ),
                            ),

                            const SizedBox(height: 20.0),

                            const Divider(
                              height: 1.0,
                              color: Colors.black,
                            ),

                            const SizedBox(height: 15.0),

                            // Long description may need to scroll within the page.
                            SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * .015,
                                ),
                                child: Text(
                                  product.description,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 22, 114, 220),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Creator: ${product.userId} \n${product.saveTime} Created\n${product.modifyTime} Modified',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 22, 114, 220),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          child: Icon(userProvider.isInWishlist(_product!.id!)
                              ? Icons.check
                              : Icons.shopping_cart),
                          onPressed: () {
                            if (userProvider.isInWishlist(_product!.id!)) {
                              userProvider.removeFromWishlist(_product!.id!);
                            } else {
                              userProvider.addToWishlist(_product!.id!);
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
