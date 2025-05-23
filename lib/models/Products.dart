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

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void removeQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1 && cartItems[index].quantity > 0) {
      cartItems[index].quantity--;
      if (cartItems[index].quantity == 0) {
        cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void addToCart(ProductItem product) {
    final existingCartItem = _cartItems.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    if (!_cartItems.contains(existingCartItem)) {
      existingCartItem.quantity = 1;
      _cartItems.add(existingCartItem);
    } else {
      existingCartItem.quantity++;
    }
    notifyListeners();
  }

  void removeFromCart(ProductItem product) {
    final existingCartItem = _cartItems.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );
    if (existingCartItem.quantity > 0) {
      existingCartItem.quantity--;
      if (existingCartItem.quantity == 0) {
        _cartItems.remove(existingCartItem);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isEmpty() => _cartItems.isEmpty;
}

String formatNumber(String number) {
  String cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
  if (cleanNumber.length <= 3) return cleanNumber;
  final buffer = StringBuffer();
  int offset = cleanNumber.length % 3;
  if (offset > 0) {
    buffer.write(cleanNumber.substring(0, offset));
    if (cleanNumber.length > 3) buffer.write(' ');
  }
  for (int i = offset; i < cleanNumber.length; i += 3) {
    buffer.write(cleanNumber.substring(i, i + 3));
    if (i + 3 < cleanNumber.length) buffer.write(' ');
  }
  return buffer.toString();
}
