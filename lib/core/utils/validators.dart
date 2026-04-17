/// Validates an Indian mobile phone number (10 digits, optional +91 prefix)
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) return 'Phone number is required';
  final cleaned = value.replaceAll(RegExp(r'\D'), '');
  if (cleaned.length != 10) return 'Enter a valid 10-digit phone number';
  return null;
}

/// Validates that a name is not empty and has minimum length
String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Name is required';
  if (value.trim().length < 2) return 'Name must be at least 2 characters';
  return null;
}

/// Validates age as a positive integer
String? validateAge(String? value) {
  if (value == null || value.isEmpty) return 'Age is required';
  final age = int.tryParse(value);
  if (age == null) return 'Enter a valid age';
  if (age < 1 || age > 120) return 'Age must be between 1 and 120';
  return null;
}

/// Formats phone for display: e.g. +91 ****** 21
String maskPhone(String phone) {
  final cleaned = phone.replaceAll(RegExp(r'\D'), '');
  if (cleaned.length < 4) return '+91 $cleaned';
  final last2 = cleaned.substring(cleaned.length - 2);
  return '+91 ******$last2';
}
