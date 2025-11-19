import 'package:uuid/uuid.dart';

class AuthenticationUser {
  final String id;            // ID local (UUID)
  final String? backendId;    // ID real del backend Roble
  final String name;
  final String email;

  // ⚠️ Roble NO devuelve password, así que debe ser opcional.
  final String? password;

  final String? accessToken;   // Token real del backend
  final String? refreshToken;  // Opcional: Roble lo devuelve en login

  AuthenticationUser({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.backendId,
    this.accessToken,
    this.refreshToken,
  });

  /// Crear usuario local desde datos del signup/login
  factory AuthenticationUser.create({
    required String name,
    required String email,
    String? password,
    String? backendId,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthenticationUser(
      id: const Uuid().v4(),
      name: name,
      email: email,
      password: password,
      backendId: backendId,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Crear un usuario directamente desde el JSON de Roble
  factory AuthenticationUser.fromRoble(Map<String, dynamic> json) {
    return AuthenticationUser(
      id: const Uuid().v4(),                   // local
      backendId: json["id"],                   // Roble user ID
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      password: null,                          // Roble NO devuelve password
    );
  }

  factory AuthenticationUser.fromJson(Map<String, dynamic> json) {
    return AuthenticationUser(
      id: json["id"] ?? const Uuid().v4(),
      backendId: json["backendId"],
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      password: json["password"],             // opcional
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "backendId": backendId,
        "name": name,
        "email": email,
        "password": password,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
