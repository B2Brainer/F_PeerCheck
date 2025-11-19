import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:f_clean_template/features/auth/ui/controller/authentication_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final controllerFirstName = TextEditingController();
  final controllerLastName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();

  AuthenticationController authenticationController = Get.find();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  // -----------------------------
  // VALIDADORES
  // -----------------------------
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "El correo es obligatorio";

    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return "Correo inválido";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "La contraseña es obligatoria";
    if (value.length < 6) return "Debe tener mínimo 6 caracteres";
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Confirme la contraseña";
    if (value != controllerPassword.text) return "Las contraseñas no coinciden";
    return null;
  }

  // -----------------------------
  // SIGN UP
  // -----------------------------
  Future<void> _signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final fullName = "$firstName $lastName";

      await authenticationController.signup(fullName, email, password);

      Get.snackbar(
        "Cuenta creada",
        "La cuenta se creó exitosamente",
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );

      await Future.delayed(const Duration(milliseconds: 300));

      // Navegar al login
      Get.back();
    } catch (err) {
      logError("Error de signup: $err");

      String msg = "No se pudo crear la cuenta";

      final errStr = err.toString();

      if (errStr.contains("EMAIL_EXISTS") ||
          errStr.contains("already exists") ||
          errStr.contains("duplicate key")) {
        msg = "El correo ya está registrado";
      } else if (errStr.contains("invalid email")) {
        msg = "Correo inválido";
      } else if (errStr.contains("network") ||
                 errStr.contains("SocketException")) {
        msg = "Sin conexión a internet";
      }

      Get.snackbar(
        "Error al crear cuenta",
        msg,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.error, color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF026CD2),
      body: SafeArea(
        child: Column(
          children: [
            // ---------------------
            // HEADER
            // ---------------------
            Container(
              height: screenHeight * 0.15,
              width: screenWidth,
              color: const Color(0xFF026CD2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 24),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Crear Cuenta",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),


            // ---------------------
            // CUERPO FORMULARIO
            // ---------------------
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // NOMBRE
                          _label("Nombre"),
                          _input(controllerFirstName,
                              validator: (v) => v == null || v.isEmpty
                                  ? "El nombre es obligatorio"
                                  : null),
                          const SizedBox(height: 16),

                          // APELLIDO
                          _label("Apellido"),
                          _input(controllerLastName,
                              validator: (v) => v == null || v.isEmpty
                                  ? "El apellido es obligatorio"
                                  : null),
                          const SizedBox(height: 16),

                          // EMAIL
                          _label("Correo Electrónico"),
                          _input(controllerEmail,
                              validator: _validateEmail),
                          const SizedBox(height: 16),

                          // CONTRASEÑA
                          _label("Contraseña"),
                          _input(
                            controllerPassword,
                            obscure: _obscurePassword,
                            validator: _validatePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // CONFIRMAR CONTRASEÑA
                          _label("Confirmar Contraseña"),
                          _input(
                            controllerConfirmPassword,
                            obscure: _obscureConfirmPassword,
                            validator: _validateConfirmPassword,
                            suffix: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // TÉRMINOS Y CONDICIONES
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                activeColor: const Color(0xFF026CD2),
                                onChanged: (v) => setState(() {
                                  _acceptTerms = v ?? false;
                                }),
                              ),
                              const Expanded(
                                child: Text(
                                  "Acepto los términos y condiciones",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    color: Color(0xFF858597),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // BOTÓN CREAR CUENTA
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: Obx(() {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF026CD2),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: authenticationController
                                        .isLoading.value
                                    ? null
                                    : () async {
                                        if (!_acceptTerms) {
                                          Get.snackbar(
                                            "Términos",
                                            "Debe aceptar los términos para continuar",
                                            snackPosition:
                                                SnackPosition.BOTTOM,
                                            icon: const Icon(
                                              Icons.warning,
                                              color: Colors.orange,
                                            ),
                                          );
                                          return;
                                        }

                                        if (_formKey.currentState!
                                            .validate()) {
                                          await _signup(
                                            controllerFirstName.text.trim(),
                                            controllerLastName.text.trim(),
                                            controllerEmail.text.trim(),
                                            controllerPassword.text.trim(),
                                          );
                                        }
                                      },
                                child: authenticationController
                                        .isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Crear Cuenta",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              );
                            }),
                          ),

                          const SizedBox(height: 25),

                          // YA TIENE CUENTA
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "¿Ya tienes una cuenta? ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Color(0xFF858597),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: const Text(
                                  "Iniciar sesión",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF026CD2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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

  // ---------------------
  // HELPERS
  // ---------------------
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF858597),
      ),
    );
  }

  Widget _input(
    TextEditingController controller, {
    String? Function(String?)? validator,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF026CD2), width: 2),
        ),
        suffixIcon: suffix,
      ),
      validator: validator,
    );
  }
}
