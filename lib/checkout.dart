import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nova_lap/model/Product.dart';
import 'package:nova_lap/thankyou.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.laptop});

  final Product laptop;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _mobileController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _discountCodeController = TextEditingController();

  String? _selectedCardBrand;
  bool _isStudentDiscountApplied = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_detectCardBrandFromNumber);
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_detectCardBrandFromNumber);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _mobileController.dispose();
    _cardNumberController.dispose();
    _discountCodeController.dispose();
    super.dispose();
  }

  void _detectCardBrandFromNumber() {
    final text = _cardNumberController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _selectedCardBrand = null;
      });
      return;
    }

    final firstChar = text[0];
    if (firstChar == '5') {
      _selectedCardBrand = 'Mastercard';
    } else if (firstChar == '4') {
      _selectedCardBrand = 'Visa';
    } else if (firstChar == '3') {
      _selectedCardBrand = 'American Express';
    } else {
      _selectedCardBrand = null;
    }
    setState(() {});
  }

  bool _onlyLettersAndSpaces(String value) {
    final reg = RegExp(r'^[a-zA-Z ]+');
    return reg.hasMatch(value.trim());
  }

  double _calculateTotalPrice() {
    final basePrice = widget.laptop.price;
    final tax = basePrice * 0.13;
    const shipping = 25.0;

    var total = basePrice + tax + shipping;
    if (_isStudentDiscountApplied) {
      total = total * 0.9;
    }
    return total;
  }

  void _applyDiscountCode() {
    final code = _discountCodeController.text.trim();

    if (_isStudentDiscountApplied) {
      return;
    }

    if (code.toLowerCase() == 'cdoon95') {
      setState(() {
        _isStudentDiscountApplied = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student discount applied (10% discount).')),
      );
    } else {
      setState(() {
        _isStudentDiscountApplied = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid discount code.')),
      );
    }
  }

  void _removeDiscount() {
    setState(() {
      _isStudentDiscountApplied = false;

    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student discount removed.')),
    );
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final total = _calculateTotalPrice();

    final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
    final email = _emailController.text.trim();

    final cardNumber = _cardNumberController.text.trim();
    String maskedCard = '';
    if (cardNumber.length >= 4) {
      final last4 = cardNumber.substring(cardNumber.length - 4);
      maskedCard = '**** **** **** $last4';
    } else {
      maskedCard = '**** **** **** ${cardNumber.padLeft(4, '*')}';
    }

    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ThankYouPage(
          orderId: orderId,
          product: widget.laptop,
          totalAmount: total,
          customerName: fullName,
          customerEmail: email,
          maskedCardNumber: maskedCard,
        ),
      ),
    );
  }

  Widget _buildCardBrandChips() {
    return Row(
      children: [
        _CardBrandChip(
          label: 'Mastercard',
          isSelected: _selectedCardBrand == 'Mastercard',
        ),
        const SizedBox(width: 8),
        _CardBrandChip(
          label: 'Visa',
          isSelected: _selectedCardBrand == 'Visa',
        ),
        const SizedBox(width: 8),
        _CardBrandChip(
          label: 'Amex',
          isSelected: _selectedCardBrand == 'American Express',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotalPrice();
    final basePrice = widget.laptop.price;
    final discountAmount = _isStudentDiscountApplied ? basePrice * 0.1 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Laptop: ${widget.laptop.name}'),
              Text('Brand: ${widget.laptop.brand}'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter first name';
                        }
                        if (!_onlyLettersAndSpaces(value)) {
                          return 'Only letters allowed';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter last name';
                        }
                        if (!_onlyLettersAndSpaces(value)) {
                          return 'Only letters allowed';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value.trim())) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Country',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (!_onlyLettersAndSpaces(value)) {
                          return 'Only letters allowed';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'State',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (!_onlyLettersAndSpaces(value)) {
                          return 'Only letters allowed';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'City',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (!_onlyLettersAndSpaces(value)) {
                          return 'Only letters allowed';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _postalCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Postal Code',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 10,
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (!RegExp(r'^\d+').hasMatch(v)) {
                    return 'Only digits allowed';
                  }
                  if (v.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text('Payment Information'),
              const SizedBox(height: 8),
              _buildCardBrandChips(),
              const SizedBox(height: 8),

              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 16,
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (!RegExp(r'^\d+').hasMatch(v)) {
                    return 'Only digits allowed';
                  }
                  if (_selectedCardBrand == 'American Express') {
                    if (v.length != 15) {
                      return 'Amex card must be 15 digits';
                    }
                  } else if (_selectedCardBrand == 'Mastercard' ||
                      _selectedCardBrand == 'Visa') {
                    if (v.length != 16) {
                      return 'Visa/Mastercard must be 16 digits';
                    }
                  } else {
                    return 'Card must start with 5, 4, or 3';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Expiry (MM/YY)',
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text;
                          if (text.isEmpty) {
                            return newValue;
                          }
                          if (text.length > 5) {
                            return oldValue;
                          }
                          if (text.length == 1) {
                            final c = text[0];
                            if (c != '0' && c != '1') {
                              return oldValue;
                            }
                            return newValue;
                          }

                          if (text.length >= 2) {
                            final mStr = text.substring(0, 2);
                            final month = int.tryParse(mStr);
                            if (month == null || month < 1 || month > 12) {
                              return oldValue;
                            }
                          }

                          if (text.length >= 3 && text[2] != '/') {
                            return oldValue;
                          }

                          return newValue;
                        }),
                      ],
                      maxLength: 5,
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) {
                          return 'Required';
                        }
                        if (!RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})').hasMatch(v)) {
                          return 'Use MM/YY format';
                        }
                        final match =
                            RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})').firstMatch(v)!;
                        final mm = int.parse(match.group(1)!);
                        final yy = int.parse(match.group(2)!);

                        final now = DateTime.now();
                        final expYear = 2000 + yy;
                        final expMonth = mm;
                        final expiryDate = DateTime(expYear, expMonth + 1, 0);
                        final maxAllowed =
                            DateTime(now.year + 7, now.month, now.day);

                        if (expiryDate.isBefore(now)) {
                          return 'Card expired';
                        }
                        if (expiryDate.isAfter(maxAllowed)) {
                          return 'Expiry more than 7 years ahead';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 4,
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) {
                          return 'Required';
                        }
                        if (!RegExp(r'^\d+').hasMatch(v)) {
                          return 'Only digits allowed';
                        }
                        if (_selectedCardBrand == 'American Express') {
                          if (v.length != 4) {
                            return 'Amex CVV must be 4 digits';
                          }
                        } else if (_selectedCardBrand == 'Mastercard' ||
                            _selectedCardBrand == 'Visa') {
                          if (v.length != 3) {
                            return 'CVV must be 3 digits';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text('Student Discount'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _discountCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Discount Code',
                      ),
                      enabled: !_isStudentDiscountApplied,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isStudentDiscountApplied ? null : _applyDiscountCode,
                    child: const Text('Apply'),
                  ),
                  const SizedBox(width: 8),
                  if (_isStudentDiscountApplied)
                    TextButton(
                      onPressed: _removeDiscount,
                      child: const Text('Remove'),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              Text('Laptop price: \$${widget.laptop.price.toStringAsFixed(2)}'),
              if (_isStudentDiscountApplied)
                Text(
                  'Student discount: -\$${discountAmount.toStringAsFixed(2)} (10% discount)',
                ),
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text('Place Order (\$${total.toStringAsFixed(2)})'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardBrandChip extends StatelessWidget {
  const _CardBrandChip({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.credit_card,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
