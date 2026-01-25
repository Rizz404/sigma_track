extension NumExtension on num {
  /// Format number as IDR (Rupiah) currency string
  /// Example: 1500000.toRupiah() => "Rp 1.500.000"
  String toRupiah() {
    final formatter = _RupiahFormatter();
    return formatter.format(this);
  }

  /// Format number as IDR (Rupiah) currency string with short format
  /// Example: 1500000.toRupiahShort() => "Rp 1.5M"
  String toRupiahShort() {
    if (this >= 1000000) {
      return 'Rp ${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return 'Rp ${(this / 1000).toStringAsFixed(1)}K';
    }
    return 'Rp ${toStringAsFixed(0)}';
  }
}

class _RupiahFormatter {
  String format(num value) {
    final intValue = value.toInt();
    final stringValue = intValue.toString();
    return 'Rp ${_formatWithDots(stringValue)}';
  }

  String _formatWithDots(String value) {
    if (value.length <= 3) return value;

    final result = StringBuffer();
    int count = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result.write('.');
      }
      result.write(value[i]);
      count++;
    }

    return result.toString().split('').reversed.join('');
  }
}
