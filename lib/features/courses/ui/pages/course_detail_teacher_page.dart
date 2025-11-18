import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/course_controller.dart';

class CourseEnrollmentPage extends StatelessWidget {
  final String courseId;
  final String courseName;
  final String? courseCode;
  final bool isStudentView;

  const CourseEnrollmentPage({
    super.key,
    required this.courseId,
    required this.courseName,
    this.courseCode,
    this.isStudentView = false,
  });

  @override
  Widget build(BuildContext context) {
    final CourseController courseController = Get.find();
    final bool showCode = courseCode != null && !isStudentView;

    return Scaffold(
      appBar: AppBar(title: Text('Estudiantes - $courseName')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCode) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Código de Acceso',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        courseCode!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Comparte este código con los estudiantes para que se inscriban',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Estudiantes inscritos:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final enrolledUsers = courseController.getEnrolledUsers(
                  courseId,
                );

                if (enrolledUsers.isEmpty) {
                  return const Center(
                    child: Text('No hay estudiantes inscritos en este curso'),
                  );
                }

                return ListView.builder(
                  itemCount: enrolledUsers.length,
                  itemBuilder: (context, index) {
                    final userEmail = enrolledUsers[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(userEmail),
                        trailing: !isStudentView
                            ? IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  courseController.unenrollUser(courseId);
                                },
                              )
                            : null,
                      ),
                    );
                  },
                );
              }),
            ),
            if (!isStudentView) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Get.snackbar(
                          'Próximamente',
                          'Función de invitación por correo estará disponible pronto',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const Text('Invitar por Correo'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
