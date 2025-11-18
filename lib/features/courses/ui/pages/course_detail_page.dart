import 'package:f_clean_template/features/courses/ui/controller/course_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:f_clean_template/core/app_theme.dart'; 

class CourseDetailPage extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String teacherEmail;

  const CourseDetailPage({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.teacherEmail,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final CourseController courseController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<RolePalette>()!;
    final Color accent = palette.estudianteAccent;
    final Color cardBg = palette.estudianteCard;
    final Color surface = palette.surfaceSoft;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.courseName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Container(
        color: surface,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 18,
                  height: 4,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Clase',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Profesor: ${widget.teacherEmail}',
                style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 16),

            // Controles
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                

            Text('Actividades',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            if (activities.isEmpty)
              const Center(child: Text('No hay actividades en esta categoría'))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final a = activities[index];
                  return Card(
                    color: cardBg,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Get.snackbar(
                          'Próximamente',
                          'La evaluación de compañeros estará disponible pronto.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.assignment_outlined,
                                size: 28, color: accent),
                            const SizedBox(height: 8),
                            Text(a.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FilledButton.tonalIcon(
                                onPressed: null, // disabled V1
                                icon: const Icon(Icons.rate_review_outlined),
                                label: const Text('Evaluar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
