import 'dart:io';
import 'package:staj_test1/themes/app_theme.dart';
import 'package:staj_test1/main.dart'; // main.dart dosyanı import et (themeNotifier için)

import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;

  const ProfileScreen({super.key, required this.name, required this.email});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    String? imagePath = prefs.getString("profileImage");

    if (imagePath != null) {
      setState(() {
        profileImage = File(imagePath);
      });
    }
  }

  Future<void> openCamera() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          profileImage = File(image.path);
        });
      }
    }
  }

  Future<void> openGallery() async {
    print("Galeri butonuna basıldı");

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    print("Seçilen resim: $image");

    if (image != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profileImage", image.path);
      setState(() {
        profileImage = File(image.path);
      });
    } else {
      print("İzin verilmedi.");
    }
  }

  Future<void> showPhotoOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.pagePadding),
        child: Column(
          children: [
            const SizedBox(height: 40),

            Stack(
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : null,
                  child: profileImage == null
                      ? Icon(
                          Icons.person,
                          size: 65,
                          color: colorScheme.primary,
                        )
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primary,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: AppTheme.white,
                        size: 18,
                      ),
                      onPressed: showPhotoOptions,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.itemSpacing),

            Text(
              widget.name,
              style: theme.textTheme.headlineMedium,
            ),

            const SizedBox(height: 8),

            Text(
              widget.email,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 30),

            // ==================================================
            // DARK / LIGHT TEMA DEĞİŞTİRME KARTI
            // ==================================================
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.cardPadding,
                  vertical: 4,
                ),
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: colorScheme.primary,
                  ),
                ),
                title: Text(
                  "Karanlık Mod",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: AppTheme.bodyFont,
                  ),
                ),
                subtitle: Text(
                  isDarkMode ? "Açık (Dark Mode)" : "Kapalı (Light Mode)",
                  style: theme.textTheme.bodySmall,
                ),
                trailing: Switch(
                  value: isDarkMode,
                  activeColor: colorScheme.primary,
                  onChanged: (bool value) {
                    // Tıklandığında main.dart içindeki global bildirimi güncelliyoruz
                    themeNotifier.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: AppTheme.buttonHeight,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                ),

                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Çıkış Yap",
                  style: TextStyle(
                    fontSize: AppTheme.buttonFont,
                    fontWeight: AppTheme.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}