import 'package:arjun_guruji/features/EventManagement/domain/entity/organiser.dart';

class OrganizerInfoModel extends OrganizerInfoEntity {
  OrganizerInfoModel({
    required super.name,
    required super.email,
    required super.phone,
    super.instagram,
    super.facebook,
  });

  factory OrganizerInfoModel.fromMap(Map<String, dynamic> map) {
    return OrganizerInfoModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      instagram: map['instagram'],
      facebook: map['facebook'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'instagram': instagram,
      'facebook': facebook,
    };
  }
}
