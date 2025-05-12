import 'package:flutter/material.dart';
import 'package:shop/models/Products.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.counts,
    required this.showMoreButtons,
    required this.count,
    required this.onAdd,
    required this.onRemove,
  });

  final ProductItem product;
  final Map<int, int> counts;
  final Map<int, bool> showMoreButtons;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      key: ValueKey(product.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 202,
              height: 202,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  product.image,
                  width: 202,
                  height: 202,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0, top: 5.0),
            child: Container(
              width: double.infinity, // Растягивает контейнер на всю доступную ширину
              alignment: Alignment.center, // Центрирует текст внутри контейнера
              child: Text(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Arial",
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          if (showMoreButtons[product.id] == true)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "${product.cost} руб.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Arial",
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 5),
          Center(
            // Оберните Row в Center
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // Центрируем содержимое
              children: [
                if (showMoreButtons[product.id] == true) ...[
                  IconButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.black12,
                      ),
                      fixedSize: MaterialStateProperty.all(Size(25, 25)),
                    ),
                    onPressed: onRemove,
                    icon: Icon(Icons.remove),
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: "Arial",
                        fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.black12,
                      ),
                      fixedSize: MaterialStateProperty.all(Size(25, 25)),
                    ),
                    onPressed: onAdd,
                    icon: Icon(Icons.add),
                    color: Colors.black,
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 40.0),
                    child: Text(
                      "${product.cost} руб.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Arial",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 30.0),
                    child: IconButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.orange,
                        ),
                        fixedSize: MaterialStateProperty.all(Size(25, 25)),
                      ),
                      onPressed: onAdd,
                      icon: Icon(Icons.add, color: Colors.white, size: 25),
                    ),
                  ),

                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
