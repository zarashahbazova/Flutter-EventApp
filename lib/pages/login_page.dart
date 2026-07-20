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

  final TextEditingController usernameController = //textfield tek basına tazıyı saklamaz, controller saklar ve sürekli güncellenir
      TextEditingController();

  final TextEditingController passwordController = 
      TextEditingController();

  @override
  void initState() { //bir kere çalisiyor, isLoggedIn = true ise otomatik homepage acicak
    super.initState();
    checkLogin();
  }

  // Future<void> checkLogin() async {
  //   final prefs = await SharedPreferences.getInstance();    //telefonun local hafızasını açıyor

  //   bool? isLoggedIn = prefs.getBool("isLoggedIn");

  //   String? username = prefs.getString("username");

  //   if (username != null && email != null) { //name!=null -> kullanici daha önce giris yapmis
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Navigator.pushReplacement(      //daha önce giris yapmissa login sayfasını siliyor homepage acılıyor
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => HomePage(
  //             name: name,
  //             email: email,
  //           ),
  //         ),
  //       );
  //     });
  //   }
  // }

  Future<void> checkLogin() async {

    final prefs = await SharedPreferences.getInstance(); 

    bool isLoggedIn =
        prefs.getBool("isLoggedIn") ?? false;

    if (!isLoggedIn) return;

    //simdilik otomatik giris yapmiyo

  }

  Future<void> login() async { 

    if (!_formKey.currentState!.validate()) return; //tüm validatorları tek tek çağiriyor, hepsi doğruysa true dönüyor

    final user = await DatabaseHelper.instance.login( //sqlite b ağlantısı (database helper y)

      usernameController.text.trim(),

      passwordController.text.trim(),

    );

    if (user == null) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "Kullanıcı adı veya şifre yanlış.",
          ),

        ),

      );

      return;

    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", true);

    await prefs.setInt("userId", user.id!);

    await prefs.setString(
      "username",
      user.username,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          name: user.fullName,
          email: user.email,
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [

          Positioned(        //kare
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Container(
                  height: 600,
                  color: Theme.of(context).colorScheme.primary,
                
                ),

            Positioned(
              top: 300,
              left: 0,
              right: 0,
              child: Container(
                height: 520,
                decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowColor,
                      //color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 5),
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
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                        const SizedBox(height: 280),

                        const SizedBox(height: 0),
                        Text(
                          "Giriş Yapın",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        
                        const SizedBox(height: 20),
                        

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
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      //cursorColor: const Color.fromARGB(255, 83, 5, 5),
                      decoration: InputDecoration(
                        labelText: "Kullanıcı Adı",
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: const Color.fromARGB(10, 9, 55, 45),



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
                      //cursorColor: const Color.fromARGB(255, 9, 55, 45),
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
           
                        labelText: "Şifre",
                        // prefixIcon: const Icon(
                        //   Icons.email,
                        //   color: Color.fromARGB(80, 9, 55, 45)
                        //   ),
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: const Color.fromARGB(10, 9, 55, 45),


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

                        const Text("Hesabın yok mu?"),

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
                  ]
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
