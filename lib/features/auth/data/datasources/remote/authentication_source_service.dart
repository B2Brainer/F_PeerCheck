import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:f_clean_template/features/auth/domain/models/authentication_user.dart';
import 'package:f_clean_template/features/auth/data/datasources/remote/i_authentication_source.dart';

class AuthenticationSourceService implements IAuthenticationSource {

  // CONFIGURACIÓN ROBLE
  final String baseUrl = "https://roble-api.openlab.uninorte.edu.co/auth";
  final String dbName = "peercheck_8b796c5f03";

  // ============================================================
  // LOGIN
  // ============================================================
  @override
  Future<AuthenticationUser> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/$dbName/login");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Credenciales incorrectas");
    }

    final data = jsonDecode(res.body);

    // Roble devuelve SOLO accessToken y refreshToken
    final access = data["accessToken"];
    final refresh = data["refreshToken"];

    if (access == null || refresh == null) {
      throw Exception("Roble respondió con un formato inesperado");
    }

    // Construimos el usuario
    final user = AuthenticationUser(
      id: const Uuid().v4(),
      backendId: null,
      name: email.split("@").first,
      email: email,
      password: null,
      accessToken: access,
      refreshToken: refresh,
    );

    await _saveCurrentUser(user);

    return user;
  }

  // ============================================================
  // SIGNUP DIRECT
  // ============================================================
  @override
  Future<AuthenticationUser> signup(
      String name, String email, String password) async {

    final url = Uri.parse("$baseUrl/$dbName/signup-direct");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name,
      }),
    );

    if (res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data["message"] ?? "No se pudo crear la cuenta");
    }

    // robles NO devuelve tokens en signup-direct → hacemos login
    return await login(email, password);
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  @override
  Future<void> logout() async {
    final user = await getCurrentUser();
    if (user == null) return;

    final url = Uri.parse("$baseUrl/$dbName/logout");

    await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${user.accessToken}",
      },
    );

    await _clearCurrentUser();
  }

  // ============================================================
  // SESSION: GET CURRENT USER
  // ============================================================
  @override
  Future<AuthenticationUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("current_user");

    if (raw == null) return null;

    return AuthenticationUser.fromJson(jsonDecode(raw));
  }

  // ============================================================
  // HELPERS
  // ============================================================
  Future<void> _saveCurrentUser(AuthenticationUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("current_user", jsonEncode(user.toJson()));
  }

  Future<void> _clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("current_user");
  }
}
