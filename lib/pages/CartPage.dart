import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/Products.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    void onAdd(int productId) {
      cartProvider.addQuantity(productId);
    }

    void onRemove(int productId) {
      cartProvider.removeQuantity(productId);
    }

    int calculateTotalPrice() {
      int total = 0;
      for (var cartItem in cartProvider.cartItems) {
        total += cartItem.product.cost * cartItem.quantity;
      }
      return total;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'cartButton',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Space between title and right text
          children: [
            Text(
              "Корзина",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // Add your right-side text here
            TextButton(
              onPressed: () {},
              child: Text(
                "Очистить", // Replace with your desired text
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body:
          cartProvider.cartItems.isEmpty
              ? Center(
                child: Text(
                  'Корзина пуста',
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 8.0,
                    ),
                    child: Container(
                      width: double.infinity, // Stretch to full width
                      padding: const EdgeInsets.all(8.0), // Add some padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // Space between items
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Align text to the left
                            children: [
                              Text(
                                'ул. Дементьева, д.1В',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Arial",
                                ),
                              ),
                              Text(
                                'Казань',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Arial",
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '823 м',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Arial",
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartProvider.cartItems[index];

                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 3,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    cartItem.product.image,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.checklist,
                                          color: Colors.black54,
                                          size: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                        ),
                                        Text(
                                          "Настроить",
                                          style: TextStyle(
                                            fontFamily: "Arial",
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.brunch_dining_sharp,
                                          color: Colors.black54,
                                          size: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                        ),
                                        Text(
                                          "Собрать комбо",
                                          style: TextStyle(
                                            fontFamily: "Arial",
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                  Colors.black12,
                                                ),
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                  Size(25, 25),
                                                ),
                                          ),
                                          onPressed: () {
                                            onRemove(cartItem.product.id);
                                          },
                                          icon: const Icon(Icons.remove),
                                          color: Colors.black,
                                          splashRadius: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            cartItem.quantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                  Colors.black12,
                                                ),
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                  Size(25, 25),
                                                ),
                                          ),
                                          onPressed:
                                              () => onAdd(cartItem.product.id),
                                          icon: const Icon(Icons.add),
                                          color: Colors.black,
                                          splashRadius: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 40.0,
                                          ),
                                          child: Text(
                                            '${cartItem.product.cost * cartItem.quantity} руб',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Итого',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${calculateTotalPrice()} руб.',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Optional spacing between text and button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              // Set your desired color here
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ), // 0 for fully square corners
                              ),
                            ),
                            onPressed: () {
                              // Handle checkout action
                            },
                            child: const Text(
                              'Оформить заказ',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: "Arial",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
