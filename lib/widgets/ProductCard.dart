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
      color: Colors.black,
      key: ValueKey(product.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 200,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  product.image,
                  width: 200,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0, top: 5.0),
            child: Text(
              "${product.cost} ₽",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 17,
                color: Colors.purple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Text(
              product.salesman,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Text(
              product.name,
              textAlign: TextAlign.left,
              maxLines: 1,
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.deepOrange, size: 14),
                Text(
                  "${product.rating}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Arial",
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    formatNumber(product.reviews.toString()),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Arial",
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              showMoreButtons[product.id] == true
                  ? Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(Icons.remove),
                    color: Colors.white,
                  ),
                  Padding(padding: const EdgeInsets.only(left: 38.0)),
                  Text(
                    count.toString(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 38.0)),
                  IconButton(
                    onPressed: onAdd,
                    icon: Icon(Icons.add),
                    color: Colors.white,
                  ),
                ],
              )
                  : Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.purple,
                    ),
                  ),
                  onPressed: onAdd,
                  child: Text(
                    'В корзину',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}