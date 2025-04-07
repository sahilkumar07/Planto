import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

import 'auth_controller.dart';
import 'login_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _selectedFile; // for mobile
  Uint8List? _webImageBytes; // for web
  String? _imageName;

  Future<void> _pickFromGallery(BuildContext context) async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.first.bytes != null) {
        setState(() {
          _webImageBytes = result.files.first.bytes!;
          _imageName = result.files.first.name;
          _selectedFile = null;
        });
        VxToast.show(context, msg: "Picked: $_imageName");
      }
    } else {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
          _webImageBytes = null;
          _imageName = pickedFile.name;
        });
        VxToast.show(context, msg: "Picked: $_imageName");
      }
    }
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    if (kIsWeb) {
      VxToast.show(context, msg: "Camera not supported on Web");
    } else {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
          _webImageBytes = null;
          _imageName = pickedFile.name;
        });
        VxToast.show(context, msg: "Captured: $_imageName");
      }
    }
  }

  void _logout(BuildContext context) async {
    setState(() {
      _selectedFile = null;
      _webImageBytes = null;
      _imageName = null;
    });

    await FirebaseAuth.instance.signOut();

    final controller = Get.find<AuthController>();
    controller.clearLoginFields();

    VxToast.show(context, msg: "Logged out");

    Get.offAll(() => const LoginScreen());
  }

  Widget _buildImagePreview(double imageSize) {
    if (kIsWeb && _webImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          _webImageBytes!,
          fit: BoxFit.contain,
          height: imageSize,
          width: imageSize,
        ),
      );
    } else if (!kIsWeb && _selectedFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _selectedFile!,
          fit: BoxFit.contain,
          height: imageSize,
          width: imageSize,
        ),
      );
    } else {
      return const Center(
        child:
            Text("No image selected", style: TextStyle(color: Colors.grey)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.75;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detect Plant Disease"),
        backgroundColor: const Color.fromARGB(255, 55, 173, 232),
        actions: [
          TextButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Use Camera"),
                      onPressed: () => _pickFromCamera(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Pick from Gallery"),
                      onPressed: () => _pickFromGallery(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_imageName != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "Selected: $_imageName",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                  height: imageSize,
                  width: imageSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _buildImagePreview(imageSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
