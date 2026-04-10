import 'package:flutter/material.dart';
import 'package:nova_lap/model/Product.dart';
import 'package:nova_lap/home.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({
    super.key,
    required this.orderId,
    required this.product,
    required this.totalAmount,
    required this.customerName,
    required this.customerEmail,
    required this.cardholderName,
    required this.maskedCardNumber,
  });

  final String orderId;
  final Product product;
  final double totalAmount;
  final String customerName;
  final String customerEmail;
  final String cardholderName;
  final String maskedCardNumber;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.firstImageSrc;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you for your order!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Order ID: $orderId'),
            const SizedBox(height: 16),

            if (imageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Text('Image unavailable'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Product: ${product.name}'),
            Text('Brand: ${product.brand}'),
            const SizedBox(height: 8),
            const Text(
              'Order Status: Processing',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text(
              'Customer Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Name: $customerName'),
            Text('Email used: $customerEmail'),
            Text('Cardholder: $cardholderName'),
            Text('Card used: $maskedCardNumber'),
            const SizedBox(height: 16),
            const Text(
              'Payment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Home()),
                    (route) => false,
                  );
                },
                child: const Text('Continue Shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
