import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import '../database/database_helper.dart';
import '../themes/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); //formu kontrol etmek icin

  final TextEditingController
  usernameController = //textfield tek basına tazıyı saklamaz, controller saklar ve sürekli güncellenir
      TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    //bir kere çalisiyor, isLoggedIn = true ise otomatik homepage acicak
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    if (!isLoggedIn) return;

    String name = prefs.getString("fullName") ?? "";

    String email = prefs.getString("email") ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (_) => HomePage(name: name, email: email),
        ),
      );
    });
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate())
      return; //tüm validatorları tek tek çağiriyor, hepsi doğruysa true dönüyor

    final user = await DatabaseHelper.instance.login(
      //sqlite b ağlantısı (database helper y)
      usernameController.text.trim(),

      passwordController.text.trim(),
    );

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı adı veya şifre yanlış.")),
      );

      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", true);

    await prefs.setInt("userId", user.id!);

    await prefs.setString("username", user.username);

    await prefs.setString("fullName", user.fullName);

    await prefs.setString("email", user.email);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(name: user.fullName, email: user.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            //kare
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Container(
                  height: 600,
                  color: AppTheme.loginPageBG, // arkaplandaki yeşil renk
                ),
                Positioned(
                  top: 300,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 520,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface, //arkaplan beyaz renk
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          //TODO: color: AppTheme.buttonColor,

                          //  blurRadius: AppTheme.shadowBlur,
                          // offset: AppTheme.shadowOffset,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.pagePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    const SizedBox(height: 260),
                    Text(
                      "Giriş Yapın",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    const SizedBox(height: 40),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Devam etmek için bilgilerinizi girin.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Kullanıcı Adı",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Kullanıcı adı giriniz.";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: passwordController,

                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Şifre",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Şifre giriniz.";
                        }

                        if (value.length < 6) {
                          return "Şifre en az 6 karakter olmalıdır.";
                        }

                        return null;
                      },
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        onPressed: () async {
                          await login();
                        },
                        child: const Text("Giriş Yap"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hesabın yok mu?",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text("Kayıt Ol"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
