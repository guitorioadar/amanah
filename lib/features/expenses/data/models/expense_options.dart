/// A selectable expense category from `GET /expense-categories/dropdown`.
class ExpenseCategoryOption {
  const ExpenseCategoryOption({required this.id, required this.title});

  factory ExpenseCategoryOption.fromJson(Map<String, dynamic> json) =>
      ExpenseCategoryOption(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
      );

  final int id;
  final String title;
}

/// A selectable client from `GET /clients/dropdown`.
class ClientOption {
  const ClientOption({
    required this.id,
    required this.name,
    this.email,
    this.businessName,
    this.profilePictureUrl,
    this.businessLogoUrl,
  });

  factory ClientOption.fromJson(Map<String, dynamic> json) => ClientOption(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        email: json['email'] as String?,
        businessName: json['business_name'] as String?,
        profilePictureUrl: json['profile_picture_url'] as String?,
        businessLogoUrl: json['business_logo_url'] as String?,
      );

  final int id;
  final String name;
  final String? email;
  final String? businessName;
  final String? profilePictureUrl;
  final String? businessLogoUrl;
}
