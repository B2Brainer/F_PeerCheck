import 'package:f_clean_template/features/auth/domain/models/authentication_user.dart';
import 'package:f_clean_template/features/auth/domain/repositories/i_auth_repository.dart';

class AuthenticationUseCase {
  final IAuthRepository repository;

  AuthenticationUseCase(this.repository);

  Future<AuthenticationUser> login(String email, String password) {
    return repository.login(email, password);
  }

  Future<AuthenticationUser> signup(
      String name, String email, String password) {
    return repository.signup(name, email, password);
  }

  Future<void> logout() {
    return repository.logout();
  }

  Future<AuthenticationUser?> getCurrentUser() {
    return repository.getCurrentUser(); // ✔
  }
}
