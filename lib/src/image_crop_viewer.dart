import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:yuni_widget/yuni_widget.dart';
import 'image_crop_controller.dart';
import 'image_editor_widget.dart';

/// 一个预置好的图片裁剪页面容器，包含 Scaffold、AppBar 和完成按钮。
class ImageCropViewer extends StatefulWidget {
  final Uint8List imageBytes;
  final double? aspectRatio;
  final int quality;

  /// 自定义 AppBar 标题，默认为 "裁剪图像"
  final String? titleText;

  /// “完成”按钮的文案，默认为 "完成"
  final String? finishText;

  /// 自定义的 AppBar。如果提供，将使用此 AppBar 替代默认生成的 AppBar。
  final PreferredSizeWidget? appBar;

  const ImageCropViewer({
    super.key,
    required this.imageBytes,
    this.aspectRatio,
    this.quality = 70,
    this.titleText,
    this.finishText,
    this.appBar,
  });

  @override
  State<ImageCropViewer> createState() => _ImageCropViewerState();
}

class _ImageCropViewerState extends State<ImageCropViewer> {
  late final ImageCropController _controller;

  final config = YuniWidgetConfig.instance;

  @override
  void initState() {
    super.initState();
    _controller = ImageCropController();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: widget.appBar ??
            AppBar(
              title: Text(widget.titleText ?? "裁剪图像"),
              centerTitle: true,
            ),
        body: SafeArea(
          child: Stack(
            children: [
              // 使用受控的裁剪画布
              Positioned.fill(
                child: ImageEditorWidget(
                  imageBytes: widget.imageBytes,
                  controller: _controller,
                  aspectRatio: widget.aspectRatio,
                ),
              ),
              // 右下角的“完成”按钮
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: YButton.filled(
                    text: widget.finishText ?? "完成",
                    textStyle: config.textStyles.bodyLargeBold,
                    borderRadius: config.radius.borderFull,
                    padding: EdgeInsets.symmetric(
                      vertical: config.spacing.sm + config.spacing.xxs,
                      horizontal: config.spacing.lg + config.spacing.xs,
                    ),
                    onPressed: () async {
                      final closeFun = YLoadingDialogHelper.showLoading(
                        context: context,
                      );
                      try {
                        final File? croppedFile = await _controller.cropAndSave(
                          quality: widget.quality,
                        );
                        closeFun();
                        if (!context.mounted) return;
                        Navigator.of(context).pop(croppedFile);
                      } catch (e) {
                        closeFun();
                        if (context.mounted) {
                          Navigator.of(context).pop(null);
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
