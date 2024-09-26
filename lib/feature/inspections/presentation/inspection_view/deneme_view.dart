import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DenemeView extends StatefulWidget {
  const DenemeView({super.key});

  @override
  _DenemeViewState createState() => _DenemeViewState();
}

class _DenemeViewState extends State<DenemeView> {
  File? _imageFile;

  Future<void> _getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File processedImage = await _rotateImageIfNeeded(File(image.path));
      setState(() {
        _imageFile = processedImage;
      });
    }
  }

  Future<File> _rotateImageIfNeeded(File image) async {
    // Resmi oku
    final bytes = await image.readAsBytes();
    final originalImage = img.decodeImage(bytes)!;
    print("originalImage.width: ${originalImage.width}");
    print("originalImage.height: ${originalImage.height}");
    // Genişlik ve yükseklik kontrolü
    // if (originalImage.width > originalImage.height) {
    //   // Yatay (landscape) ise döndür
    //   final rotatedImage = img.copyRotate(originalImage, angle: 90);

    //   // Yeni dosya yolu oluştur ve kaydet
    //   final documentPath = (await getApplicationDocumentsDirectory()).path;
    //   final newFilePath = '$documentPath/rotated_${path.basename(image.path)}';

    //   // Rotated resmi kaydet
    //   final File newFile = File(newFilePath)..writeAsBytesSync(img.encodeJpg(rotatedImage, quality: 100));

    //   return newFile;
    // }

    // Eğer resim dikey veya kare ise, orijinal dosyayı döndür
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker Example')),
      body: Center(
        child: _imageFile == null ? const Text('No image selected.') : Image.file(_imageFile!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImageFromCamera,
        tooltip: 'Pick Image',
        child: const Icon(Icons.camera),
      ),
    );
  }
}
