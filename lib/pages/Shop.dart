import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class ProductItem with ChangeNotifier {
  final int id;
  final String name;
  final int cost;
  final String image;

  ProductItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.image,
  });

  factory ProductItem.fromRow(Map<String, dynamic> row) {
    return ProductItem(
      id: row['id'] as int,
      name: row['name'] as String,
      cost: row['cost'] as int,
      image: row['image'] as String,
    );
  }
}

Future<List<ProductItem>> fetchProducts() async {
  final connection = PostgreSQLConnection(
    '10.0.2.2',
    5432,
    'shopdb',
    username: 'postgres',
    password: 'Daniil1910',
  );

  await connection.open();

  final results = await connection.mappedResultsQuery('SELECT * FROM product');

  await connection.close();

  return results.map((row) => ProductItem.fromRow(row['product']!)).toList();
}

class CartItem {
  final ProductItem product;
  int quantity;

  CartItem({required this.product, this.quantity = 0});
}

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  Map<int, int> _counts = {};
  List<CartItem> _cartItems = [];
  Map<int, bool> _showMoreButtons = {};

  void _updateCart(ProductItem product, int count) {
    if (count > 0) {
      final existingCartItem = _cartItems.firstWhere(
            (item) => item.product.id == product.id,
        orElse: () => CartItem(product: product),
      );

      if (existingCartItem.quantity == 0) {
        _cartItems.add(existingCartItem);
      }

      existingCartItem.quantity = count;
    } else {
      _cartItems.removeWhere((item) => item.product.id == product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Магазин",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.white70,
      body: FutureBuilder<List<ProductItem>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет товаров'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                int count = _counts[product.id] ?? 0;

                return Card(
                  color: Colors.white24,
                  elevation: 10,
                  key: ValueKey(product.id),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            product.image,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(product.name),
                      Text(product.cost.toString()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _showMoreButtons[product.id] == true
                              ? Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (count > 0) {
                                    setState(() {
                                      _counts[product.id] = --count;
                                      _updateCart(product, count);
                                      if(_counts[product.id] == 0)
                                        _showMoreButtons[product.id] = false;
                                    });
                                  }
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Text(count.toString()),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _counts[product.id] = ++count;
                                    _updateCart(product, count);
                                  });
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          )
                              : ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white70)),
                            onPressed: () {
                              setState(() {
                                _showMoreButtons[product.id] = true;
                                _counts[product.id] = ++count;
                                _updateCart(product, count);
                              });
                            },
                            child: Text('В корзину'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Cart(cartItems: _cartItems),
            ),
          );
        },
        child: Icon(Icons.shopping_cart),
        backgroundColor: Colors.white24,
        foregroundColor: Colors.black,
      ),
    );
  }
}


class Cart extends StatelessWidget {
  final List<CartItem> cartItems;

  const Cart({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Корзина",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white70,
      body:
          cartItems.isEmpty
              ? Center(child: Text('Корзина пуста'))
              : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return Card(
                    color: Colors.white24,
                    child: Row(
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              cartItem.product.image,
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(cartItem.product.name),
                            subtitle: Text('Количество: ${cartItem.quantity}'),
                            trailing: Text(
                              'Цена: ${cartItem.product.cost * cartItem.quantity}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
