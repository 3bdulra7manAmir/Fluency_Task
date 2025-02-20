import 'package:chewie/chewie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluency/Features/teachers/presentation/controllers/video_controller.dart';
import 'package:fluency/Core/widgets/Containers/custom_container.dart';
import 'package:fluency/Core/constants/app_borders.dart';
import 'package:fluency/Core/constants/app_colors.dart';
import 'package:fluency/Core/constants/app_padding.dart';

class CustomTeachersBnbDetails2 extends ConsumerWidget {
  const CustomTeachersBnbDetails2({
    super.key,
    required this.videoUrl,
    required this.teacherIMGPath,
  });

  final String videoUrl;
  final String teacherIMGPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = ref.watch(videoProvider);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(videoProvider.notifier).loadVideo(videoUrl);
          },
          child: CustomContainer(
            containerMargin: AppPadding().k24Horizontal,
            containerAlignment: Alignment.center,
            containerHeight: 191.h,
            containerWidth: 327.w,
            containerDecoration: BoxDecoration(
              borderRadius: AppBorders().radiusCircular16,
              color: AppColors.kTeachersVideoBGColor,
            ),
            containerChild: Stack(
              alignment: Alignment.center,
              children: [
                // Background Image
                CachedNetworkImage(imageUrl: teacherIMGPath, fit: BoxFit.cover, height: 222.h, width: 132.w,),

                // Play Button if Video is NOT initialized
                if (videoController == null || !videoController.value.isInitialized)
                  SvgPicture.asset('assets/images/svg/Teachers_View_PlayButton.svg'),

                // Video Player with Controls
                if (videoController != null && videoController.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: Chewie(
                        controller: ChewieController(
                          videoPlayerController: videoController,
                          autoPlay: true,
                          looping: false,
                          allowFullScreen: false,
                          allowPlaybackSpeedChanging: false,
                          showControls: true, // Enables play/pause and seek bar
                          aspectRatio: videoController.value.aspectRatio,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
