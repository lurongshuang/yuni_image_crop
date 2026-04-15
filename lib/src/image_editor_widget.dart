import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:yuni_widget/yuni_widget.dart';
import 'image_crop_controller.dart';

/// 核心裁剪交互组件，不含页面 Scaffold/AppBar
class ImageEditorWidget extends StatelessWidget {
  final Uint8List imageBytes;
  final ImageCropController controller;
  final double? aspectRatio;
  final double maxScale;
  final Color? backgroundColor;

  const ImageEditorWidget({
    super.key,
    required this.imageBytes,
    required this.controller,
    this.aspectRatio,
    this.maxScale = 8.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final config = YuniWidgetConfig.instance;

    return Container(
      color: backgroundColor ?? config.colors.background,
      child: ExtendedImage.memory(
        imageBytes,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: controller.editorKey,
        fit: BoxFit.contain,
        initEditorConfigHandler: (ExtendedImageState? state) {
          return EditorConfig(
            maxScale: maxScale,
            hitTestBehavior: HitTestBehavior.deferToChild,
            cropAspectRatio: aspectRatio ?? CropAspectRatios.ratio1_1,
            cornerSize: const Size(30.0, 3.0),
          );
        },
      ),
    );
  }
}
