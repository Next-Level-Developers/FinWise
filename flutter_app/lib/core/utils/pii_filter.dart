class PiiFilter {
  Map<String, dynamic> sanitize(Map<String, dynamic> input) {
    final Map<String, dynamic> copy = Map<String, dynamic>.from(input);
    copy.remove('email');
    copy.remove('phoneNumber');
    copy.remove('displayName');
    return copy;
  }
}
