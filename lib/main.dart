import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Giriş',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> { 
  final _formKey = GlobalKey<FormState>(); //formu kontrol etmek icin

  final TextEditingController nameController = TextEditingController(); //isim ve eposta ktuusna yazılan yazıyı tutuoyr
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();    //telefonun local hafızasını açıyor

    String? name = prefs.getString("name"); //daha önce kaydedilmis olan isim ve mailleri okuyor
    String? email = prefs.getString("email");

    if (name != null && email != null) { //name!=null -> kullanici daha önce giris yapmis
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(      //daha önce giris yapmissa login sayfasını siliyor homepage acılıyor
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              name: name,
              email: email,
            ),
          ),
        );
      });
    }
  }

  Future<void> saveUser() async { //isim ve mail tel hafizasıan kaydediliyor uygulama kapansa da silinimyor
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", nameController.text.trim());
    await prefs.setString("email", emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  color: const Color(0xFF496860),
                
                ),

            Positioned(
              top: 300,
              left: 0,
              right: 0,
              child: Container(
                height: 520,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
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

                const Text(
                  "Giriş Yapın",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(200, 9, 55, 45),
                  ),
                ),
              

                const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Devam etmek için bilgilerinizi girin.",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(220, 158, 158, 158),
                  ),
                ),
              ),


                const SizedBox(height: 20),

                TextFormField(
                  controller: nameController,
                  cursorColor: const Color.fromARGB(255, 9, 55, 45),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(180, 9, 55, 45),
                    ),
                    labelText: "İsim",
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color.fromARGB(80, 9, 55, 45)
                      ),
                    filled: true,
                    fillColor: const Color.fromARGB(10, 9, 55, 45),


                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(49, 9, 55, 66),
                        width: 2,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                  ),

                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "İsim boş bırakılamaz";
                    }

                    if (value.trim().length < 2) {
                      return "İsim en az 2 karakter olmalıdır";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: emailController,
                  cursorColor: const Color.fromARGB(255, 9, 55, 45),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(180, 9, 55, 45),
                    ),
                    labelText: "E-posta",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color.fromARGB(80, 9, 55, 45)
                      ),
                    filled: true,
                    fillColor: const Color.fromARGB(10, 9, 55, 45),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(49, 9, 55, 66),
                        width: 2,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                  ),

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "E-posta giriniz";
                    }

                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegex.hasMatch(value)) {
                      return "Geçerli bir e-posta giriniz";
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
                      if (_formKey.currentState!.validate()) { //
                        await saveUser();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(180, 9, 55, 45),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      
                    ),
                    child: const Text(
                      "Giriş Yap",
                      style: TextStyle(fontSize: 18),
                      

                    ),
                  ),
                ),

                const SizedBox(height: 80),
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

