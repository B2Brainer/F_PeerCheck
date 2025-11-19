import 'package:f_clean_template/features/auth/domain/models/authentication_user.dart';
import 'package:f_clean_template/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:f_clean_template/features/auth/data/datasources/remote/i_authentication_source.dart';

class AuthRepository implements IAuthRepository {
  final IAuthenticationSource source;

  AuthRepository(this.source);

  @override
  Future<AuthenticationUser> login(String email, String password) {
    return source.login(email, password);
  }

  @override
  Future<AuthenticationUser> signup(
      String name, String email, String password) {
    return source.signup(name, email, password);
  }

  @override
  Future<void> logout() {
    return source.logout();
  }

  @override
  Future<AuthenticationUser?> getCurrentUser() {
    return source.getCurrentUser(); // ✔
  }
}
