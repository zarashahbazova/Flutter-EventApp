// import 'package:flutter/material.dart';

// import '../database/database_helper.dart';
// import '../models/user.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {

//   final _formKey = GlobalKey<FormState>();

//   final fullNameController = TextEditingController();

//   final usernameController = TextEditingController();

//   final emailController = TextEditingController();

//   final passwordController = TextEditingController();

//   final confirmPasswordController = TextEditingController();


//   Future<void> register() async {

//   if (!_formKey.currentState!.validate()) return;

//   final username = usernameController.text.trim();

//   final email = emailController.text.trim();

//   final usernameCheck =
//       await DatabaseHelper.instance
//           .getUserByUsername(username);

//   if (usernameCheck != null) {

//     ScaffoldMessenger.of(context).showSnackBar(

//       const SnackBar(

//         content: Text(
//           "Bu kullanıcı adı kullanılıyor.",
//         ),

//       ),

//     );

//     return;

//   }

//   final user = User(

//     fullName: fullNameController.text.trim(),

//     username: username,

//     email: email,

//     password: passwordController.text,

//   );

//   await DatabaseHelper.instance.createUser(user);

//   if (!mounted) return;

//   ScaffoldMessenger.of(context).showSnackBar(

//     const SnackBar(

//       content: Text("Kayıt başarılı."),

//     ),

//   );

//   Navigator.pop(context);

// }

// }

// validator: (value) {

//   if (value == null || value.trim().isEmpty) {
//     return "Ad Soyad zorunludur.";
//   }

//   return null;

// },

// validator: (value) {

//   if (value == null || value.isEmpty) {
//     return "Kullanıcı adı zorunludur.";
//   }

//   if (value.length < 4) {
//     return "En az 4 karakter olmalı.";
//   }

//   final regex = RegExp(r'^[a-zA-Z0-9_]+$');

//   if (!regex.hasMatch(value)) {
//     return "Sadece harf, rakam ve _ kullanabilirsiniz.";
//   }

//   return null;

// },


// validator: (value) {

//   if (value == null || value.length < 6) {
//     return "Şifre en az 6 karakter olmalı.";
//   }

//   return null;

// },

// validator: (value) {

//   if (value != passwordController.text) {
//     return "Şifreler uyuşmuyor.";
//   }

//   return null;

// },


// import 'package:flutter/material.dart';

// class RegisterPage extends StatelessWidget {
//   const RegisterPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text("Register Page"),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    final existing = await DatabaseHelper.instance
        .getUserByUsername(usernameController.text.trim());

    if (existing != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu kullanıcı adı zaten kullanılıyor.")),
      );
      return;
    }

    final user = User(
      fullName: fullNameController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    await DatabaseHelper.instance.createUser(user);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kayıt başarılı.")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label, IconData icon) => InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: deco("Ad Soyad", Icons.person),
                validator: (v)=> v==null||v.trim().isEmpty ? "Ad Soyad giriniz":null,
              ),
              const SizedBox(height:16),
              TextFormField(
                controller: usernameController,
                decoration: deco("Kullanıcı Adı", Icons.account_circle),
                validator: (v){
                  if(v==null||v.trim().isEmpty) return "Kullanıcı adı giriniz";
                  if(v.length<4) return "En az 4 karakter";
                  return null;
                },
              ),
              const SizedBox(height:16),
              TextFormField(
                controller: emailController,
                decoration: deco("E-posta", Icons.email),
                validator: (v){
                  if(v==null||v.trim().isEmpty) return "E-posta giriniz";
                  final r=RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if(!r.hasMatch(v)) return "Geçerli e-posta giriniz";
                  return null;
                },
              ),
              const SizedBox(height:16),
              TextFormField(
                controller: passwordController,
                obscureText:true,
                decoration: deco("Şifre", Icons.lock),
                validator:(v)=>v==null||v.length<6?"Şifre en az 6 karakter":null,
              ),
              const SizedBox(height:16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText:true,
                decoration: deco("Şifre Tekrar", Icons.lock_outline),
                validator:(v)=>v!=passwordController.text?"Şifreler uyuşmuyor":null,
              ),
              const SizedBox(height:30),
              SizedBox(
                height:55,
                child: ElevatedButton(
                  onPressed: register,
                  child: const Text("Kayıt Ol"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
