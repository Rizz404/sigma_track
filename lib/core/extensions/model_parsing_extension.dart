import 'package:sigma_track/core/utils/logging.dart';

/// Extension untuk parsing model dengan type safety dan logging informatif
///
/// Contoh penggunaan:
/// ```dart
/// factory UserModel.fromMap(Map<String, dynamic> map) {
///   return UserModel(
///     id: map.getField<String>('id'),              // Required field
///     email: map.getFieldOrNull<String>('email'), // Optional field
///     createdAt: map.getDateTime('createdAt'),    // DateTime support
///   );
/// }
/// ```
extension SafeMap on Map<String, dynamic> {
  /// Get field dengan type checking
  /// Throw error jika field null/missing atau tipe tidak sesuai
  T getField<T>(String key) {
    try {
      final value = this[key];

      if (value == null) {
        this.logError('Field "$key" is null or missing');
        throw Exception('Field "$key" is null or missing');
      }

      if (value is! T) {
        this.logError(
          'Field "$key" has wrong type\n'
          '   Expected: $T\n'
          '   Got: ${value.runtimeType}\n'
          '   Value: $value',
        );
        throw Exception(
          'Field "$key" has wrong type. Expected $T but got ${value.runtimeType}',
        );
      }

      return value;
    } catch (e) {
      this.logError(
        'Error at field "$key": $e\n'
        '   📦 Available keys: ${keys.toList()}\n'
        '   🔍 Value: ${this[key]}',
      );
      rethrow;
    }
  }

  /// Get field nullable, return null jika field tidak ada atau tipe tidak sesuai
  T? getFieldOrNull<T>(String key) {
    try {
      final value = this[key];
      if (value == null) return null;

      if (value is! T) {
        this.logData(
          'Field "$key" type mismatch (returning null)\n'
          '   Expected: $T\n'
          '   Got: ${value.runtimeType}',
        );
        return null;
      }

      return value as T?;
    } catch (e) {
      this.logData('Warning at field "$key": $e');
      return null;
    }
  }

  /// Get DateTime field dengan support multiple format
  DateTime getDateTime(String key) {
    final value = this[key];

    if (value == null) {
      this.logError('DateTime field "$key" is null or missing');
      throw Exception('DateTime field "$key" is null or missing');
    }

    try {
      // String ISO format
      if (value is String) {
        return DateTime.parse(value);
      }

      // Milliseconds timestamp
      if (value is int) {
        return DateTime.parse(value.toString());
      }

      // Already DateTime
      if (value is DateTime) {
        return value;
      }

      this.logError(
        'DateTime field "$key" has unsupported type\n'
        '   Expected: String | int | DateTime\n'
        '   Got: ${value.runtimeType}',
      );
      throw Exception('Unsupported DateTime type for field "$key"');
    } catch (e) {
      this.logError('Error parsing DateTime "$key": $e');
      rethrow;
    }
  }

  /// Get DateTime nullable
  DateTime? getDateTimeOrNull(String key) {
    try {
      final value = this[key];
      if (value == null) return null;

      if (value is String) return DateTime.parse(value);
      if (value is int) return DateTime.parse(value.toString());
      if (value is DateTime) return value;

      this.logData(
        'DateTime field "$key" has unsupported type (returning null)\n'
        '   Got: ${value.runtimeType}',
      );
      return null;
    } catch (e) {
      this.logData('Warning parsing DateTime "$key": $e');
      return null;
    }
  }

  /// Get double field, handling int values from backend (adds .00 if int)
  double getDouble(String key) {
    final value = this[key];

    if (value == null) {
      this.logError('Field "$key" is null or missing');
      throw Exception('Field "$key" is null or missing');
    }

    if (value is double) return value;
    if (value is int) return value.toDouble();

    this.logError(
      'Field "$key" has wrong type\n'
      '   Expected: double or int\n'
      '   Got: ${value.runtimeType}\n'
      '   Value: $value',
    );
    throw Exception(
      'Field "$key" has wrong type. Expected double or int but got ${value.runtimeType}',
    );
  }

  /// Get double field nullable, handling int values from backend
  double? getDoubleOrNull(String key) {
    try {
      final value = this[key];
      if (value == null) return null;

      if (value is double) return value;
      if (value is int) return value.toDouble();

      this.logData(
        'Field "$key" type mismatch (returning null)\n'
        '   Expected: double or int\n'
        '   Got: ${value.runtimeType}',
      );
      return null;
    } catch (e) {
      this.logData('Warning at field "$key": $e');
      return null;
    }
  }
}
