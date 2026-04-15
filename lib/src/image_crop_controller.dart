import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// 图片裁剪控制器，负责管理裁剪状态和执行裁剪逻辑
class ImageCropController {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  /// 获取当前裁剪画布的状态
  ExtendedImageEditorState? get editorState => editorKey.currentState;

  /// 执行裁剪并返回 File
  Future<File?> cropAndSave({
    int quality = 80,
    String? format,
  }) async {
    final Uint8List? bytes = await cropAndBytes(quality: quality);
    if (bytes == null) return null;

    final Directory tempDir = await getTemporaryDirectory();
    final String extension = format ?? 'jpg';
    final String tempPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.$extension';
    final File tempFile = File(tempPath);
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  /// 执行裁剪并返回字节数据 (Uint8List)
  Future<Uint8List?> cropAndBytes({
    int quality = 80,
  }) async {
    final ExtendedImageEditorState? state = editorState;
    if (state == null) return null;

    /// 1. 获取裁剪区域
    final Rect? cropRect = state.getCropRect();
    if (cropRect == null) return null;

    /// 2. 获取原始图像数据
    final Uint8List? originalUint8List = state.rawImageData;
    if (originalUint8List == null) return null;

    /// 3. 将原始图像数据解码为 ui.Image
    final ui.Codec codec = await ui.instantiateImageCodec(originalUint8List);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image originalImage = frameInfo.image;

    /// 4. 创建一个新的 PictureRecorder，把裁剪区域画出来
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final dstSize = Size(cropRect.width, cropRect.height);
    canvas.translate(-cropRect.left, -cropRect.top);

    /// 5. 把原图画到画布上
    canvas.drawImage(originalImage, Offset.zero, Paint());

    /// 6. 生成新的 ui.Image
    final ui.Image croppedImage = await recorder.endRecording().toImage(
      dstSize.width.toInt(),
      dstSize.height.toInt(),
    );

    /// 7. 转成 PNG 字节作为压缩源
    final ByteData? byteData = await croppedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) return null;
    final Uint8List pngBytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
    );

    /// 8. 使用 flutter_image_compress 压缩为 JPEG
    final Uint8List compressedBytes =
        await FlutterImageCompress.compressWithList(
          pngBytes,
          quality: quality,
          format: CompressFormat.jpeg,
        );

    return compressedBytes;
  }
}
