import 'package:finalterm_project/model/product.dart';
import 'package:finalterm_project/model/product_repository.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListState();
}

class _WishListState extends State<WishListPage> {
  @override
  List<Widget> _buildListCards(BuildContext context) {
    UserRepository userProvider =
        Provider.of<UserRepository>(context, listen: false);
    List<String> wishlist = userProvider.wishlistItems;
    ProductRepository productRepository =
        Provider.of<ProductRepository>(context, listen: false);

    return wishlist.map(
      (productId) {
        ProductModel product = productRepository.getProduct(productId);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 15.0, 2.0, 15.0),
            child: Stack(
              children: [
                ListTile(
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      product.image!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(product.name),
                ),
                Positioned(
                  // Positioned 위젯은 Stack 내에서 절대 위치를 지정할 수 있습니다.
                  right: 15, // 오른쪽으로부터의 거리
                  bottom: 2, // 아래로부터의 거리
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    onPressed: () async {
                      userProvider.removeFromWishlist(product.id!);
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wish List'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade600,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: _buildListCards(context),
      ),
    );
  }
}
