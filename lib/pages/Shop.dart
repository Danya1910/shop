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
        title: const Text("Магазин", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: FutureBuilder<List<ProductItem>>(
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
              child: Text('Нет товаров', style: TextStyle(color: Colors.white)),
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
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
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
                    _animationController.reset();
                    _animationController.forward();
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
                      _animationController.reset();
                      _animationController.forward();
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
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
          child: const Icon(Icons.shopping_cart),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}


