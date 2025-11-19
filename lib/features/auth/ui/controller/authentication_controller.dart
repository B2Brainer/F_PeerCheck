import 'dart:convert';
import 'package:get/get.dart';
import 'package:f_clean_template/features/auth/domain/models/authentication_user.dart';
import 'package:f_clean_template/features/auth/domain/use_case/authentication_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  final AuthenticationUseCase useCase;

  AuthenticationController(this.useCase);

  final Rxn<AuthenticationUser> currentUser = Rxn<AuthenticationUser>();
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;

  bool get isLogged => currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    loadRememberedCredentials();
    _loadSavedSession();
  }

  // --------------------------------------------------------
  // LOGIN
  // --------------------------------------------------------
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final user = await useCase.login(email, password);
      currentUser.value = user;

      await _saveSession(user);

      if (rememberMe.value) {
        await saveRememberedCredentials(email, password);
      } else {
        await clearRememberedCredentials();
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------------------------------------
  // SIGNUP
  // --------------------------------------------------------
  Future<void> signup(String name, String email, String password) async {
    try {
      isLoading.value = true;

      final user = await useCase.signup(name, email, password);
      currentUser.value = user;

      await _saveSession(user);

    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------------------------------------
  // LOGOUT
  // --------------------------------------------------------
  Future<void> logOut() async {
    await useCase.logout();
    currentUser.value = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("current_user");
  }

  // --------------------------------------------------------
  // SAVE SESSION (GUARDA USUARIO + TOKENS)
  // --------------------------------------------------------
  Future<void> _saveSession(AuthenticationUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("current_user", jsonEncode(user.toJson()));
  }

  // --------------------------------------------------------
  // AUTO-LOGIN SI EXISTE SESIÓN
  // --------------------------------------------------------
  Future<void> _loadSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("current_user");

    if (raw != null) {
      final json = jsonDecode(raw);
      currentUser.value = AuthenticationUser.fromJson(json);
    }
  }

  // --------------------------------------------------------
  // REMEMBER ME
  // --------------------------------------------------------
  String? rememberedEmail;
  String? rememberedPassword;

  Future<void> saveRememberedCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("remember_me", true);
    await prefs.setString("remembered_email", email);
    await prefs.setString("remembered_password", password);
  }

  Future<void> clearRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("remember_me");
    await prefs.remove("remembered_email");
    await prefs.remove("remembered_password");
  }

  Future<void> loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool("remember_me") ?? false;

    if (remember) {
      rememberedEmail = prefs.getString("remembered_email");
      rememberedPassword = prefs.getString("remembered_password");
      rememberMe.value = true;
    }
  }
}
