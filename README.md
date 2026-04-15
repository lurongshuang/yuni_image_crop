# yuni_image_crop

A Flutter package for image cropping, based on extended_image.

## Features

- Image cropping functionality
- Easy to use API with ImageCropHelper
- Based on extended_image for powerful image handling
- Support for image compression
- Customizable aspect ratio

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  yuni_image_crop: ^0.0.1
```

## Usage

### Using ImageCropHelper (Recommended)

`ImageCropHelper` 是一个单例类，提供了最简便的方式来打开裁剪页面：

```dart
import 'package:yuni_image_crop/yuni_image_crop.dart';
import 'dart:typed_data';
import 'dart:io';

// 使用 ImageCropHelper 打开裁剪页面
Future<void> cropImage(BuildContext context, Uint8List imageBytes) async {
  final File? croppedFile = await ImageCropHelper.instance.crop(
    context: context,
    imageBytes: imageBytes,
    aspectRatio: 1.0, // 可选：设置裁剪比例，如 1.0 为正方形
    quality: 80,      // 可选：图片压缩质量，默认 80
    titleText: '裁剪图片',  // 可选：自定义标题
    finishText: '完成',     // 可选：自定义完成按钮文字
  );
  
  if (croppedFile != null) {
    // 裁剪成功，使用裁剪后的文件
    print('裁剪后的文件路径: ${croppedFile.path}');
  }
}
```

### Using ImageCropViewer (Direct)

如果你需要更多自定义控制，可以直接使用 `ImageCropViewer`：

```dart
import 'package:yuni_image_crop/yuni_image_crop.dart';

Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => ImageCropViewer(
      imageBytes: imageBytes,
      aspectRatio: 1.0,  // 裁剪比例
      quality: 80,       // 压缩质量
      titleText: '裁剪图片',
      finishText: '完成',
    ),
  ),
);
```

### Using ImageCropController (Advanced)

如果你需要完全控制裁剪逻辑，可以使用 `ImageCropController`：

```dart
import 'package:yuni_image_crop/yuni_image_crop.dart';

final controller = ImageCropController();

// 执行裁剪并保存为文件
final File? croppedFile = await controller.cropAndSave(quality: 80);

// 或获取裁剪后的字节数据
final Uint8List? croppedBytes = await controller.cropAndBytes(quality: 80);
```

## API Reference

### ImageCropHelper

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| context | BuildContext | 是 | BuildContext |
| imageBytes | Uint8List | 是 | 图片字节数据 |
| aspectRatio | double? | 否 | 裁剪比例，如 1.0 为正方形 |
| quality | int | 否 | 图片压缩质量 (0-100)，默认 80 |
| titleText | String? | 否 | 页面标题 |
| finishText | String? | 否 | 完成按钮文字 |
| appBar | PreferredSizeWidget? | 否 | 自定义 AppBar |

## Getting Started

For more information about Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
