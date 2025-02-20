import 'package:fluency/Core/constants/app_images.dart';
import 'package:fluency/Core/utils/styles.dart';
import 'package:fluency/Core/widgets/listview_builder/custom_listbuilder.dart';
import 'package:fluency/Features/teachers/presentation/controllers/teacher_controller.dart';
import 'package:fluency/Features/teachers/presentation/screens/teachers_bms.dart';
import 'package:fluency/Features/teachers/presentation/widgets/custom_teachers_card.dart';
import 'package:fluency/Features/teachers/presentation/widgets/custom_teachers_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeachersView extends ConsumerWidget
{
  const TeachersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    final teachersListAsync = ref.watch(teachersListProvider);
    return Scaffold(
      body: Column(
        children:
        [
          const CustomTeachersAppBar(),

          26.verticalSpace,

          Text("Teachers", style: Styles.textStyle20, textAlign: TextAlign.center,),

          35.verticalSpace,

          teachersListAsync.when(
            data: (teachers) => Expanded(
              child: CustomListBuilder(
                listItemCount: teachers.length,
                listItemBuilder: (context, index)
                {
                  final teacher = teachers[index];
                  return GestureDetector(
                    onTap: () async
                    {
                      //print("Tapped on ${teacher.name}");
                      //print("Flag URL: ${teacher.nationality?.flag}");
                      //print("Accent: ${teacher.accent?.name}");
                      final teacherDetails = await ref.read(teacherRepositoryProvider).getTeacherDetails(teacher.id ?? '');

                      CustomTeachersBMS.show(
                        context,
                        teacherIMGPath: teacher.photo ?? '',
                        flagIMGPath: teacher.nationality?.flag ?? AppIMGs().kFluencyTeachersViewEGFlagPNG,
                        teacherName: teacher.name ?? '',
                        teacherNameSubtitle: teacher.headline,
                        countryText: teacher.nationality?.name ?? "N/A",
                        accentText: teacher.accent?.name ?? "N/A",
                        videoUrl: teacherDetails.video != null ? "https://api.fluency.live/${teacherDetails.video}" : null,
                      );
                    },
                    child: CustomTeachersCard(
                      teacherIMGPath: teacher.photo ?? '',
                      teacherName: teacher.name ?? '',
                      teacherNameSubtitle: teacher.headline ?? '',
                      flagIMGPath: teacher.nationality?.flag ?? AppIMGs().kFluencyTeachersViewEGFlagPNG,
                      countryText: teacher.nationality?.name ?? "N/A",
                      accentText: teacher.accent?.name ?? "N/A",
                    ),
                  );
                },
                listseparatorBuilder: (context, index) => 10.verticalSpace,
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }
}