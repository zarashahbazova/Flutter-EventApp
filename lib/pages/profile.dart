import 'dart:io';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
  });

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
       MaterialPageRoute(
         builder: (context) => const LoginPage(),
       ),
       (route) => false,
     );

  }

  Future<void> loadProfileImage() async {

    final prefs = await SharedPreferences.getInstance();

    String? imagePath =
        prefs.getString("profileImage");

    if (imagePath != null) {
      setState(() {
        profileImage = File(imagePath);
      });
    }

  }

  Future<void> openCamera() async {
    PermissionStatus status =
        await Permission.camera.request();

    if (status.isGranted) {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (image != null) {
        setState(() {
          profileImage = File(image.path);
        });
      }
    }
  }

  Future<void> openGallery() async {
    print("Galeri butonuna basıldı");

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );

      print("Seçilen resim: $image");

      if (image != null) {

        final prefs = await SharedPreferences.getInstance();

          await prefs.setString(
            "profileImage",
            image.path,
          );

        setState(() {
          profileImage = File(image.path);
        });
      }
     else {
      print("İzin verilmedi.");
    }
  }


  //  Future<void> openGallery() async {
  //   print("Galeri butonuna basıldı");

  //     PermissionStatus status = await Permission.photos.request();
  //     if (status.isGranted) {

  //         final XFile? image = await picker.pickImage(
  //           source: ImageSource.gallery,
  //         );
        
  //       print("Seçilen resim: $image");

  //       if (image != null) {

  //         final prefs = await SharedPreferences.getInstance();

  //           await prefs.setString(
  //             "profileImage",
  //             image.path,
  //           );

  //         setState(() {
  //           profileImage = File(image.path);
  //         });
  //       }
  //     }
    
  //     else if (status.isPermanentlyDenied) {

  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text("Galeri İzni"),
  //           content: const Text(
  //             "Galeriye erişebilmek için ayarlardan izin vermeniz gerekiyor.",
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("İptal"),
  //             ),
  //             FilledButton(
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //                 await openAppSettings();
  //               },
  //               child: const Text("Ayarlar"),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  // }


  Future<void> showPhotoOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library),
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 70),

            Stack(
              children: [

                CircleAvatar(
                  radius: 75,
                  backgroundColor: const Color.fromARGB(40, 2, 61, 35),
                  backgroundImage:
                      profileImage != null
                          ? FileImage(profileImage!)
                          : null,
                  child:
                      profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 65,
                              color: Color.fromARGB(180, 2, 55, 40)
                            )
                          : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color.fromARGB(255, 2, 61, 35),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: showPhotoOptions,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(widget.email),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(180, 9, 55, 45),
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20)
                  ),
                ),

                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Çıkış Yap",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ),
   

              ),
            )
          ],
        ),
      ),
    );
  }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: TextFormField(
//           decoration: const InputDecoration(
//             hintText: "Test",
//           ),
//         ),
//       ),
//     );
//   }
 }