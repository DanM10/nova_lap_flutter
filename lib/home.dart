import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nova_lap/model/Product.dart';
import 'package:nova_lap/util/ProductData.dart';

import 'detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeStat();
  }
}

class HomeStat extends State<Home> {
  final List<Product> _laptops = ProductData.products;
  List<Product> _cartLaptops = [];

  void addLaptopTocart(Product laptop){
    setState(() {
      _cartLaptops.add(laptop);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NovaLap'),
        actions: [
          IconButton(
            icon: Badge.count(
              count: _cartLaptops.length,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: _laptops.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => LaptopListBuilder(
            context,
            _laptops[index],
            index == _laptops.length - 1,
            addLaptopTocart
          ),
        ),
      ),
    );
  }
}

Widget LaptopListBuilder(
  BuildContext context,
  Product laptop,
  bool lastItem,
  Function(Product) onAdd
) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(laptop.firstImageSrc, scale: 3),
        Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(laptop.brand, style: Theme.of(context).textTheme.titleLarge),
            Row(
              spacing: 30,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detail(laptop: laptop,onAdd: onAdd,),
                      ),
                    );
                  },
                  child: Text('View'),
                ),
                ElevatedButton(
                  onPressed: () => onAdd(laptop),
                  child: Text('Add to cart'),
                ),
              ],
            ),
          ],
        ),
        Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(laptop.name, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '\$${laptop.price}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!lastItem) Divider(color: Theme.of(context).colorScheme.primary),
      ],
    ),
  );
}
