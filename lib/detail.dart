import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nova_lap/model/Product.dart';
import 'checkout.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.laptop});

  final Product laptop;

  @override
  State<StatefulWidget> createState() {
    return DetailStat();
  }
}

class DetailStat extends State<Detail> {
  Widget _carouselPhotos(Product laptop, BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height * 0.5),
      child: CarouselView.weighted(
        itemSnapping: true,
        flexWeights: const <int>[1, 7, 1],
        children: laptop.imageUrls.map((String url) {
          return Image.network(laptop.getSrc(url));
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NovaLap')),
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            _carouselPhotos(widget.laptop, context),
            Text(
              widget.laptop.brand,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              widget.laptop.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                widget.laptop.description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$${widget.laptop.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(laptop: widget.laptop),
                      ),
                    );
                  },
                  child: const Text('Proceed to Checkout'),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
