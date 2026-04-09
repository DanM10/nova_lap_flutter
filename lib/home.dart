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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: const Text('NovaLap')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: _laptops.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => laptopListBuilder(
            context,
            _laptops[index],
            index == _laptops.length - 1,
          ),
        ),
      ),
    );
  }
}

Widget laptopListBuilder(BuildContext context, Product laptop, bool lastItem) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Detail(laptop: laptop)),
      );
    },
    child: Hero(
      tag: 'laptop-${laptop.id}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 3),
              color: Color.fromARGB(20, 0, 0, 0),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                laptop.firstImageSrc,
                width: double.infinity,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              laptop.brand,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(laptop.name, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '\$${laptop.price}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
