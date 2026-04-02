class ProfileInfo {
  const ProfileInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.accountType,
    required this.memberSince,
    required this.eligibilityTags,
  });

  final String name;
  final String email;
  final String phone;
  final String address;
  final String accountType;
  final String memberSince;
  final List<String> eligibilityTags;
}
