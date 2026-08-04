import '../../domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel({
    required super.fullName,
    required super.email,
    required super.phone,
    required super.password,
  });

  factory RegisterModel.fromEntity(RegisterEntity entity) {
    return RegisterModel(
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "phone": phone,
      "email": email,
      "password": password,
    };
  }
}
