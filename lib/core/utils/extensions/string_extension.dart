extension StringExtension on String {
  String get formattedPhoneNumber {
    if (length != 11) return this;
    return '${substring(0, 3)}-${substring(3, 7)}-${substring(7)}';
  }
}
