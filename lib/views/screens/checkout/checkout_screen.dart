import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/cart_controller.dart';
import 'package:atomepet/views/widgets/app_button.dart';
import 'package:atomepet/views/widgets/app_text_field.dart';
import 'package:atomepet/views/screens/checkout/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCVVController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCVVController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    final cleanedValue = value.replaceAll(' ', '');
    if (cleanedValue.length != 16) {
      return 'Card number must be 16 digits';
    }
    return null;
  }

  String? _validateCardExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    if (!value.contains('/') || value.length != 5) {
      return 'Format: MM/YY';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    if (value.length != 3 && value.length != 4) {
      return 'CVV must be 3-4 digits';
    }
    return null;
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartController = Get.find<CartController>();

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Place order
    final order = await cartController.placeOrder();

    if (order != null) {
      // Navigate to success screen
      Get.off(
        () => OrderSuccessScreen(order: order),
        transition: Transition.fadeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary
                _buildSectionTitle(context, 'Order Summary'),
                _buildOrderSummary(context, cartController),
                const SizedBox(height: 24),

                // Shipping Information
                _buildSectionTitle(context, 'Shipping Information'),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  prefixIcon: Icons.person,
                  validator: (value) => _validateRequired(value, 'Full name'),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _addressController,
                  label: 'Address',
                  prefixIcon: Icons.home,
                  validator: (value) => _validateRequired(value, 'Address'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        controller: _cityController,
                        label: 'City',
                        prefixIcon: Icons.location_city,
                        validator: (value) => _validateRequired(value, 'City'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        controller: _zipController,
                        label: 'ZIP',
                        prefixIcon: Icons.pin_drop,
                        keyboardType: TextInputType.number,
                        validator: (value) => _validateRequired(value, 'ZIP'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Payment Information
                _buildSectionTitle(context, 'Payment Information'),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _cardNumberController,
                  label: 'Card Number',
                  prefixIcon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                  validator: _validateCardNumber,
                  hint: '1234 5678 9012 3456',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _cardExpiryController,
                        label: 'Expiry',
                        prefixIcon: Icons.calendar_today,
                        keyboardType: TextInputType.datetime,
                        validator: _validateCardExpiry,
                        hint: 'MM/YY',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        controller: _cardCVVController,
                        label: 'CVV',
                        prefixIcon: Icons.lock,
                        keyboardType: TextInputType.number,
                        validator: _validateCVV,
                        obscureText: true,
                        hint: '123',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Payment Button
                Obx(() {
                  return AppButton(
                    text: cartController.isLoading.value
                        ? 'Processing...'
                        : 'Complete Purchase',
                    icon: Icons.check_circle,
                    onPressed: cartController.isLoading.value
                        ? null
                        : _processPayment,
                  );
                }),
                
                const SizedBox(height: 16),
                
                // Security notice
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'This is a demo. No real payment will be processed.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartController controller) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            _buildSummaryRow(context, 'Items', '${controller.itemCount}'),
            const SizedBox(height: 8),
            _buildSummaryRow(
              context,
              'Subtotal',
              '\$${controller.subtotal.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              context,
              'Tax',
              '\$${controller.tax.toStringAsFixed(2)}',
            ),
            const Divider(height: 20),
            _buildSummaryRow(
              context,
              'Total',
              '\$${controller.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )
              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
      ],
    );
  }
}
