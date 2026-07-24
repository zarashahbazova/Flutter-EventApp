import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      openCamera();
    });
  }

  Future<void> openCamera() async {
    PermissionStatus status = await Permission.camera.request();

    print("Kamera izni: $status"); // <-- BURAYA EKLE


    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kamera izni verilmedi."),
          ),
        );
      }
      return;
    }

    await _picker.pickImage(
      source: ImageSource.camera,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kamera"),
      ),
      body: const Center(
        child: Text("Kamera Açılıyor..."),
      ),
    );
  }
}