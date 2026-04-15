import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'image_crop_viewer.dart';

class ImageCropHelper {
  ImageCropHelper._internal();

  static final ImageCropHelper _instance = ImageCropHelper._internal();

  factory ImageCropHelper() => _instance;

  static ImageCropHelper get instance => _instance;

  /// 打开裁剪页，返回裁剪后的 File（失败返回 null）
  Future<File?> crop({
    required BuildContext context,
    required Uint8List imageBytes,
    double? aspectRatio,
    int quality = 80,
    String? titleText,
    String? finishText,
    PreferredSizeWidget? appBar,
  }) async {
    return Navigator.of(context).push<File?>(
      MaterialPageRoute(
        builder: (_) => ImageCropViewer(
          imageBytes: imageBytes,
          aspectRatio: aspectRatio,
          quality: quality,
          titleText: titleText,
          finishText: finishText,
          appBar: appBar,
        ),
      ),
    );
  }
}
