class Validators {
  static String? requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    if (value.trim().length < 2) return '$label is too short';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
    return valid ? null : 'Enter a valid email address';
  }

  static String? password(String? value) {
    if (value == null || value.length < 8) return 'Password must be at least 8 characters';
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    return hasLetter && hasNumber ? null : 'Use letters and numbers';
  }

  static String clean(String value) {
    return value.trim().replaceAll(RegExp(r'[<>]'), '');
  }
}