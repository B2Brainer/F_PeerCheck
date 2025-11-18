import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:f_clean_template/core/app_theme.dart';
import 'package:f_clean_template/features/auth/ui/controller/authentication_controller.dart';
import '../controller/course_controller.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final controllerName = TextEditingController();
  final controllerNrc = TextEditingController();
  final controllerMaxStudents = TextEditingController(text: '30');

  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _nrcFocusNode = FocusNode();
  final FocusNode _maxStudentsFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nrcFocusNode.dispose();
    _maxStudentsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CourseController courseController = Get.find();
    AuthenticationController authController = Get.find();
    final palette = Theme.of(context).extension<RolePalette>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Curso'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF000814),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Crear Nuevo Curso',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000814),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Completa la información básica del curso',
                style: TextStyle(color: Color(0xFF5B616E), fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Campo: Nombre del Curso
              TextFormField(
                controller: controllerName,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Nombre del Curso',
                  labelStyle: TextStyle(
                    color: _nameFocusNode.hasFocus
                        ? const Color(0xFF003566)
                        : const Color(0xFF858597),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF001D3D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF001D3D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF003566),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: Color(0xFF000814)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del curso';
                  }
                  if (value.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo: NRC del Curso
              TextFormField(
                controller: controllerNrc,
                focusNode: _nrcFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'NRC del Curso',
                  labelStyle: TextStyle(
                    color: _nrcFocusNode.hasFocus
                        ? const Color(0xFF003566)
                        : const Color(0xFF858597),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF001D3D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF001D3D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF003566),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: Color(0xFF000814)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el NRC del curso';
                  }
                  if (int.tryParse(value) == null) {
                    return 'El NRC debe ser un número válido';
                  }
                  if (value.length != 5) {
                    return 'El NRC debe tener 5 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo: Límite de Estudiantes
              TextFormField(
                controller: controllerMaxStudents,
                focusNode: _maxStudentsFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Límite de Estudiantes',
                  labelStyle: TextStyle(
                    color: _maxStudentsFocusNode.hasFocus
                        ? const Color(0xFF003566)
                        : const Color(0xFF858597),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF001D3D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF001D3D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF003566),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: Color(0xFF000814)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el límite de estudiantes';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Debe ser un número válido';
                  }
                  final maxStudents = int.parse(value);
                  if (maxStudents < 1) {
                    return 'Debe haber al menos 1 estudiante';
                  }
                  if (maxStudents > 100) {
                    return 'Máximo 100 estudiantes por curso';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botones: Cancelar y Crear
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF003566)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: const Color(0xFF003566),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Obtener el nombre del usuario autenticado
                            final teacherName = 'Profesor Actual';

                            await courseController.addCourse(
                              controllerName.text.trim(),
                              int.parse(controllerNrc.text),
                              'General',
                              int.parse(controllerMaxStudents.text),
                            );

                            Get.back();

                            Get.snackbar(
                              "Curso Creado",
                              "El curso '${controllerName.text}' ha sido creado exitosamente",
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 3),
                              backgroundColor: const Color(0xFF003566),
                              colorText: Colors.white,
                            );
                          } catch (err) {
                            Get.snackbar(
                              "Error",
                              err.toString(),
                              icon: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xFF001D3D),
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF003566),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Crear Curso',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
