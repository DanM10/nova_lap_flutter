class Product {
  final String id;
  final String brand;
  final String description;
  final List<String> imageUrls;
  final String name;
  final double price;
  final int quantity;

  const Product({
    required this.id,
    required this.brand,
    required this.description,
    required this.imageUrls,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    final rawImages = json['imageUrl'] as List<dynamic>? ?? [];
    final images = rawImages
        .where((e) => e != null)
        .map((e) => e.toString())
        .toList();

    return Product(
      id: id,
      brand: json['brand'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrls: images,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'brand': brand,
    'description': description,
    'imageUrl': [null, ...imageUrls],
    'name': name,
    'price': price,
    'quantity': quantity,
  };

  @override
  String toString() => 'Product(id: $id, name: $name, brand: $brand, price: $price)';
  final String _baseUrl = 'https://quipa-pruebas-activos.atrums.com:9053/api/v1/operations/alfresco/nodes/';
  String get firstImageSrc {
    if (imageUrls.isNotEmpty) {
      return '$_baseUrl${imageUrls.first}/content?attachment=false';
    } else {
      return '';
    }
  }

  String getSrc(String nodeImg){
    return '$_baseUrl$nodeImg/content?attachment=false';
  }

}