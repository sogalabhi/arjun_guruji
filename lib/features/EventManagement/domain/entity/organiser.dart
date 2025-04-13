class OrganizerInfoEntity {
  final String name;
  final String email;
  final String phone;
  final String? instagram;
  final String? facebook;

  OrganizerInfoEntity({
    required this.name,
    required this.email,
    required this.phone,
    this.instagram,
    this.facebook,
  });
}
