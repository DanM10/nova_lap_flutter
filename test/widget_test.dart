// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_lap/model/Product.dart';
import 'package:nova_lap/thankyou.dart';

void main() {
  testWidgets('ThankYouPage shows cardholder name', (WidgetTester tester) async {
    final product = Product(
      id: 'p1',
      name: 'Test Laptop',
      brand: 'Nova',
      price: 999.99,
      description: 'Test',
      imageUrls: const [],
      quantity: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ThankYouPage(
          orderId: 'ORD123',
          product: product,
          totalAmount: 123.45,
          customerName: 'Jane Doe',
          customerEmail: 'jane@example.com',
          cardholderName: 'JANE DOE',
          maskedCardNumber: '**** **** **** 4242',
        ),
      ),
    );

    expect(find.text('Cardholder: JANE DOE'), findsOneWidget);
    expect(find.text('Card used: **** **** **** 4242'), findsOneWidget);
  });
}
