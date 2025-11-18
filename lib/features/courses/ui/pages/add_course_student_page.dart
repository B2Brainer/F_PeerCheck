import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:f_clean_template/core/app_theme.dart';
import 'package:f_clean_template/features/courses/data/datasources/local/local_course_source.dart';
import '../controller/course_controller.dart';

class CourseEnrollPage extends StatefulWidget {
  const CourseEnrollPage({super.key});

  @override
  State<CourseEnrollPage> createState() => _CourseEnrollPageState();
}

class _CourseEnrollPageState extends State<CourseEnrollPage> {
  final _formKey = GlobalKey<FormState>();
  final controllerCourseCode = TextEditingController();
  final FocusNode _courseCodeFocusNode = FocusNode();

  @override
  void dispose() {
    _courseCodeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _enrollWithCode() async {
    if (_formKey.currentState!.validate()) {
      try {
        final currentUserEmail = 'estudiante@ejemplo.com';
        final nrcCode = int.tryParse(controllerCourseCode.text);

        if (nrcCode == null) {
          Get.snackbar(
            'Error',
            'Código NRC inválido',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFFEAA7),
            colorText: Colors.black,
          );
          return;
        }

        final courseSource = Get.find<LocalCourseSource>();
        final courseToEnroll = courseSource.findCourseByNrc(nrcCode);

        if (courseToEnroll != null) {
          if (courseToEnroll.enrolledUsers.contains(currentUserEmail)) {
            Get.snackbar(
              'Ya Inscrito',
              'Ya estás inscrito en este curso: ${courseToEnroll.name}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFFFEAA7),
              colorText: Colors.black,
            );
            return;
          }

          if (!courseToEnroll.hasAvailableSpots) {
            Get.snackbar(
              'Cupo Lleno',
              'El curso ${courseToEnroll.name} no tiene cupos disponibles',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFFFEAA7),
              colorText: Colors.black,
            );
            return;
          }

          final courseController = Get.find<CourseController>();
          courseController.enrollUser(courseToEnroll.id);

          Get.back();
          Get.snackbar(
            'Inscripción Exitosa',
            'Te has inscrito al curso: ${courseToEnroll.name}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFFEAA7),
            colorText: Colors.black,
          );
        } else {
          Get.snackbar(
            'Error',
            'No se encontró un curso con el NRC: $nrcCode',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFFEAA7),
            colorText: Colors.black,
          );
        }
      } catch (err) {
        Get.snackbar(
          "Error",
          err.toString(),
          icon: const Icon(Icons.error, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFFEAA7),
          colorText: Colors.black,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<RolePalette>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscribirse a Curso'),
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
                'Ingresa el código NRC del curso',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000814),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pide el código NRC a tu profesor para inscribirte en el curso',
                style: TextStyle(color: Color(0xFF5B616E)),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cursos disponibles para prueba:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000814),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Programación Avanzada - NRC: 12345',
                        style: TextStyle(color: Color(0xFF000814)),
                      ),
                      const Text(
                        '• Diseño de Interfaces - NRC: 67890',
                        style: TextStyle(color: Color(0xFF000814)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Usa estos NRC para probar la inscripción',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF858597),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo: Código del Curso
              TextFormField(
                controller: controllerCourseCode,
                focusNode: _courseCodeFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Código del Curso (NRC)',
                  labelStyle: TextStyle(
                    color: _courseCodeFocusNode.hasFocus
                        ? const Color(0xFFD4AF37)
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
                      color: Color(0xFFD4AF37),
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
                    return 'Por favor ingresa el código del curso';
                  }
                  if (int.tryParse(value) == null) {
                    return 'El código debe ser un número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botones: Cancelar y Ingresar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFD4AF37)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: const Color(0xFFD4AF37),
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
                      onPressed: _enrollWithCode,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFFFD60A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Ingresar',
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
