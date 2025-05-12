import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/Products.dart';
import 'package:shop/widgets/ProductCard.dart';
import 'package:shop/pages/CartPage.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with SingleTickerProviderStateMixin {
  Map<int, int> _counts = {};
  Map<int, bool> _showMoreButtons = {};
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> categories = [
    'Новинки',
    'Комбо',
    'Сеты и пары',
    'Бургеры и роллы',
    'Бургеры и роллы',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.6), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.6, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 38,
              width: 38,
            ),
            const SizedBox(width: 8),
            const Text(
              "вкусно-и точка",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          tooltip: 'search',
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            tooltip: 'cart',
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const CartPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          Container(
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var category in categories)
                  TextButton(
                      onPressed: () {

                      },
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Colors.black54
                        ),
                      )
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductItem>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Ошибка: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Нет товаров',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  final products = snapshot.data!;

                  for (var product in products) {
                    _counts.putIfAbsent(product.id, () => 0);
                    _showMoreButtons.putIfAbsent(product.id, () => false);
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      int count = _counts[product.id]!;

                      return ProductCard(
                        product: product,
                        counts: _counts,
                        showMoreButtons: _showMoreButtons,
                        count: count,
                        onAdd: () {
                          setState(() {
                            _counts[product.id] = count + 1;
                            _showMoreButtons[product.id] = true;
                          });
                          cartProvider.addToCart(product);
                        },
                        onRemove: () {
                          if (count > 0) {
                            setState(() {
                              _counts[product.id] = count - 1;
                              if (_counts[product.id]! <= 0) {
                                _showMoreButtons[product.id] = false;
                              }
                            });
                            cartProvider.removeFromCart(product);
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}