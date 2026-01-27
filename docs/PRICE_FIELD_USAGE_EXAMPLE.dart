import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_price_field_helper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

/// * EXAMPLE USAGE: How to use AppTextField with price type
/// * The AppPriceFieldHelper widget will automatically show/hide based on app locale
/// * - If locale is Indonesian (id): Helper is hidden
/// * - If locale is English (en): Helper shows USD converter
/// * - If locale is Japanese (ja): Helper shows JPY converter

class PriceFieldExampleScreen extends StatefulWidget {
  const PriceFieldExampleScreen({super.key});

  @override
  State<PriceFieldExampleScreen> createState() =>
      _PriceFieldExampleScreenState();
}

class _PriceFieldExampleScreenState extends State<PriceFieldExampleScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _handleApplyConversion(String idrValue) {
    // * Apply converted value to the form field
    _formKey.currentState?.fields['price']?.didChange(idrValue);
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      // * The price value is already in IDR format (e.g., "1.000.000")
      // * To send to server, remove dots and parse to int
      String priceStr = formData['price'] ?? '0';
      String cleanPrice = priceStr.replaceAll('.', '');
      int priceInIDR = int.tryParse(cleanPrice) ?? 0;

      // TODO: Send to server
      debugPrint('Price in IDR: $priceInIDR');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Example 1: Basic price field
            const AppTextField(
              name: 'price',
              label: 'Price',
              placeHolder: 'Enter price in IDR',
              type: AppTextFieldType.price,
            ),

            // * Currency converter helper (auto show/hide based on locale)
            AppPriceFieldHelper(onApply: _handleApplyConversion),

            const SizedBox(height: 24),

            // * Example 2: Price with validation
            AppTextField(
              name: 'budget',
              label: 'Budget',
              placeHolder: 'Enter budget in IDR',
              type: AppTextFieldType.price,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Budget is required';
                }
                String cleanValue = value.replaceAll('.', '');
                int? numValue = int.tryParse(cleanValue);
                if (numValue == null || numValue < 1000) {
                  return 'Minimum budget is Rp 1.000';
                }
                return null;
              },
            ),

            AppPriceFieldHelper(
              onApply: (idrValue) {
                _formKey.currentState?.fields['budget']?.didChange(idrValue);
              },
            ),

            const SizedBox(height: 32),

            AppButton(
              text: 'Submit',
              onPressed: _submitForm,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// * HOW TO USE IN YOUR CODE:
///
/// 1. Import the widgets:
///    ```dart
///    import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
///    import 'package:sigma_track/shared/presentation/widgets/app_price_field_helper.dart';
///    ```
///
/// 2. Use AppTextField with price type:
///    ```dart
///    AppTextField(
///      name: 'price',
///      label: 'Price',
///      type: AppTextFieldType.price,
///    )
///    ```
///
/// 3. Add helper below the field (optional):
///    ```dart
///    AppPriceFieldHelper(
///      onApply: (idrValue) {
///        // Apply converted value to your field
///        _formKey.currentState?.fields['price']?.didChange(idrValue);
///      },
///    )
///    ```
///
/// 4. When submitting, clean the value:
///    ```dart
///    String priceStr = formData['price'] ?? '0';
///    String cleanPrice = priceStr.replaceAll('.', '');
///    int priceInIDR = int.tryParse(cleanPrice) ?? 0;
///    ```
///
/// * IMPORTANT NOTES:
/// - The price field only accepts IDR (Indonesian Rupiah)
/// - Format: Rp 1.000.000 (dots as thousand separators)
/// - Converter uses REAL-TIME exchange rates from Frankfurter API
/// - Falls back to static rates if API fails
/// - Converter is locale-aware (shows USD for EN, JPY for JA, hidden for ID)
/// - Actual value stored and sent to server is in IDR
/// - User is responsible for accurate conversion when using helper
///
/// * TECHNICAL DETAILS:
/// - Currency API: https://api.frankfurter.dev/v1
/// - Free, open-source, no API key required
/// - Updated daily around 16:00 CET
/// - Rates shown as "live" when from API, "fallback" when using static rates
