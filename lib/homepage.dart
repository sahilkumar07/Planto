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
  File? _selectedFile;           // for mobile
  Uint8List? _webImageBytes;     // for web
  String? _imageName;

  Future<void> _pickFromGallery(BuildContext context) async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.first.bytes != null) {
        setState(() {
          _webImageBytes = result.files.first.bytes!;
          _imageName = result.files.first.name;
          _selectedFile = null;
        });
        VxToast.show(context, msg: "Picked: $_imageName");
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
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

  Widget _buildImagePreview() {
    if (kIsWeb && _webImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          _webImageBytes!,
          fit: BoxFit.contain, // ✅ Adjusted to show full image
          height: 250,
          width: 250,
        ),
      );
    } else if (!kIsWeb && _selectedFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _selectedFile!,
          fit: BoxFit.contain, // ✅ Adjusted to show full image
          height: 250,
          width: 250,
        ),
      );
    } else {
      return const Center(
        child: Text("No image selected", style: TextStyle(color: Colors.grey)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Image"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Use Camera"),
                onPressed: () => _pickFromCamera(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text("Pick from Gallery"),
                onPressed: () => _pickFromGallery(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
              ),
              const SizedBox(height: 30),
              if (_imageName != null)
                Text("Selected: $_imageName", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                child: _buildImagePreview(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
