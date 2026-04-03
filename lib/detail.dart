import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nova_lap/model/Product.dart';

class Detail extends StatefulWidget {
  Detail({super.key, required this.laptop, required this.onAdd});

  Product laptop;
  final Function(Product) onAdd;

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
    void addThisLaptop(){
      widget.onAdd(widget.laptop);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('NovaLap')),
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
            children: [
              _carouselPhotos(widget.laptop, context),
              Text(widget.laptop.brand,style: Theme.of(context).textTheme.titleLarge,),
              Text(widget.laptop.name,style: Theme.of(context).textTheme.bodyMedium,),
              Text(widget.laptop.description, style: Theme.of(context).textTheme.bodySmall,),
              ElevatedButton(onPressed: addThisLaptop, child: Text('Add to cart'))
            ]),
      ),
    );
  }
}
