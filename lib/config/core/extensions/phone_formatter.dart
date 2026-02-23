extension PhoneFormatter on String {
  String toBackendFormat() {
    return '+${replaceAll(RegExp(r'[^\d]'), '')}';
  }

  String formatPhoneNumber() {
    // Remove all non-digit characters
    String digits = replaceAll(RegExp(r'\D'), '');

    // If empty, return empty string
    if (digits.isEmpty) return '';

    // If number starts with 998, remove it
    if (digits.startsWith('998')) {
      digits = digits.substring(3);
    }

    // Limit to 9 digits
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    // Format the number
    String result = '+998';
    if (digits.isNotEmpty) {
      result += ' ${digits.substring(0, digits.length.clamp(0, 2))}';
    }
    if (digits.length > 2) {
      result += ' ${digits.substring(2, digits.length.clamp(2, 5))}';
    }
    if (digits.length > 5) {
      result += ' ${digits.substring(5, digits.length.clamp(5, 7))}';
    }
    if (digits.length > 7) {
      result += ' ${digits.substring(7)}';
    }
    return result;
  }

  bool isValidUzbekPhoneNumber() {
    final cleanNumber = replaceAll(RegExp(r'\D'), '');
    if (cleanNumber.startsWith('998')) {
      return cleanNumber.length == 12;
    }
    return cleanNumber.length == 9;
  }
}
