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

  final TextEditingController usernameController =
      TextEditingController(); //textfield tek basına tazıyı saklamaz, controller saklar ve sürekli güncellen
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    //bir kere çalisiyor, isLoggedIn = true ise otomatik homepage acicak
    super.initState();
    DatabaseHelper.instance.resetDatabase();
    checkLogin();
  }

  Future<void> checkLogin() async {
    //bu kullanıcı daha önce giris yapmis mi diye kontrol ediyor
    final prefs =
        await SharedPreferences.getInstance(); //telefonun yerel hafizasına erişiyor önceden kayıtlı bilgiler okunuyor

    bool isLoggedIn =
        prefs.getBool("isLoggedIn") ??
        false; //tekefon hafizasına kayıtlı mı. (hiç kayıtlı değilse de varsayılan olarak false kullan)

    if (!isLoggedIn) return; // fonksiyon burda bitiyor, login ekrani aciliyor
    String name =
        prefs.getString("fullName") ??
        ""; //eğer giris yapilmissa telefon hafizasindan isim mail okuyor
    String email = prefs.getString("email") ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //frame bitince bu ekrani calistir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            name: name,
            email: email,
          ), //builder yeni sayfa oluşturan fonksiyon
        ),
      );
    });
  }

  Future<void> login() async {
    //login fonksiyonu, zaman alabilir
    if (!_formKey.currentState!
        .validate()) //önce form widgetina gidiyor, donra formun içindeki tüm textformfieldları buluyor
      return; //tüm validatorları tek tek çalistiriyo, hepsi doğruysa true dönüyor

    final user = await DatabaseHelper.instance.login(
      //sqlite bağlantısı (database helper)
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı adı veya şifre yanlış.")),
      );

      return;
    }

    final prefs =
      await SharedPreferences.getInstance(); // telefonun local hafizasini aciyo
      await prefs.setBool("isLoggedIn", true);
      await prefs.setInt("userId", user.id!);
      await prefs.setString("username", user.username);
      await prefs.setString("fullName", user.fullName);
      await prefs.setString("email", user.email);

    if (!mounted)
      return; //bu ekran hala uygylamada acık mı, değilse navşgator çalistirma

    Navigator.pushReplacement(
      // giriş başarılıysa logini kapatıp homepage acar
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
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Container(
                  height: 600,
                  color: AppTheme.loginPageBG
                   // arkaplandaki renk
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
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            // widgetı telefon sınırlarına göre düzenler
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
