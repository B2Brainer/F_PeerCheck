import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../controller/authentication_controller.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  final AuthenticationController authenticationController = Get.find();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  Future<void> _login(String email, String password) async {
    logInfo("Intentando login con $email");

    try {
      await authenticationController.login(email, password);

      Get.offAllNamed("/home"); 
    } catch (err) {
      String message = "Error inesperado";

      String e = err.toString();

      if (e.contains("Credenciales incorrectas")) {
        message = "Correo o contraseña incorrectos";
      } else if (e.contains("network") || e.contains("SocketException")) {
        message = "Sin conexión a internet";
      } else {
        message = e;
      }

      Get.snackbar(
        "Inicio fallido",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
        icon: const Icon(Icons.error, color: Colors.red),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    authenticationController.loadRememberedCredentials().then((_) {
      if (authenticationController.rememberMe.value) {
        setState(() {
          _rememberMe = true;
          controllerEmail.text =
              authenticationController.rememberedEmail ?? "";
          controllerPassword.text =
              authenticationController.rememberedPassword ?? "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF026CD2),
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(
              height: h * 0.35,
              child: Center(
                child: Image.asset(
                  "assets/images/Login_logo.png",
                  width: w * 0.8,
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: w,
                padding: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),

                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        const Text("Correo electrónico",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF858597),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controllerEmail,
                          decoration: _input("ejemplo@correo.com"),
                          validator: (v) => v == null || !GetUtils.isEmail(v)
                              ? "Correo inválido"
                              : null,
                        ),
                        const SizedBox(height: 20),

                        const Text("Contraseña",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF858597),
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextFormField(
                          controller: controllerPassword,
                          obscureText: _obscurePassword,
                          decoration: _input("Mínimo 6 caracteres",
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) =>
                              v == null || v.length < 6 ? "Min 6 caracteres" : null,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) {
                                setState(() => _rememberMe = v ?? false);
                                authenticationController.rememberMe.value =
                                    _rememberMe;
                              },
                            ),
                            const Text("Recordar mis credenciales",
                              style: TextStyle(fontSize: 12, color: Color(0xFF858597)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF026CD2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: authenticationController.isLoading.value
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        _login(
                                          controllerEmail.text.trim(),
                                          controllerPassword.text.trim(),
                                        );
                                      }
                                    },
                              child: authenticationController.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      "Iniciar sesión",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        }),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("¿No tienes una cuenta?",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF858597))),
                            GestureDetector(
                              onTap: () => Get.to(const SignUpPage()),
                              child: const Text(
                                " Regístrate",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF026CD2),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),

              ),
            ),

          ],
        ),
      ),
    );
  }

  InputDecoration _input(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: suffix,
    );
  }
}
