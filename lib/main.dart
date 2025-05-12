import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/Shop.dart';
import 'package:shop/models/Products.dart';

void main() => runApp(
  ChangeNotifierProvider(create: (context) => CartProvider(), child: MyApp()),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: ShopPage(),
    );
  }
}
