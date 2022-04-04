// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:uts205411203/page/home_page.dart';
import 'package:uts205411203/widget/tabbutton_widget.dart';
import 'package:uts205411203/page/login_screen.dart';
import 'package:uts205411203/component/color.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  static String id = 'registration_page';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

//Halaman registrasi

class _RegistrationPageState extends State<RegistrationPage> {
  bool _obscureText = true;
  bool showSpinner = false;
  String? name;
  late String email;
  late String password;
  final _text1 = TextEditingController();
  final _text2 = TextEditingController();
  final _text3 = TextEditingController();

  //Koneksi ke Firebase Auth Google

  bool _validate = false;
  final _auth = FirebaseAuth.instance;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _text1.dispose();
    _text2.dispose();
    _text3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.white30,
            ],
          )
      ),
      constraints: const BoxConstraints.expand(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueAccent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Buat Akun"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 28.0,
              ),
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 50.0,
                  child: Image.asset('assets/ebook.png'),
                ),
              ),
              //menampilkan entry nama, email dan password
              const SizedBox(
                height: 38.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: nameInput(),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: emailInput(),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: passInput(),
              ),
              const SizedBox(
                height: 18.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Hero(
                  tag: "button",
                  child: TabButton(
                    btnText: "Daftar",
                    btnTxtColor: Colors.white,
                    btnColor: PalletteColors.primaryRed,
                    btnFunction: () async {
                      (_text1.text.isEmpty ||
                          _text2.text.isEmpty ||
                          _text3.text.isEmpty)
                          ? _validate = true
                          : _validate = false;
                      setState(() {
                        showSpinner = true;
                      });
                      //simpan data dan koneksi ke firebase auth, selanjutnya masuk ke halaman homepage
                      try {
                        UserCredential newUser =
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => const HomePage()));
                          setState(() {
                            showSpinner = false;
                          });
                          return newUser;
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          // ignore_for_file: avoid_print
                          Fluttertoast.showToast(
                              msg: "The password provided is too weak",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                        } else if (e.code == 'email-already-in-use') {
                          Fluttertoast.showToast(
                              msg: "email sudah terdaftar",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: 'Error jaringan',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              //jika sudah punya akun, masuk halaman login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah punya Akun ?",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, PageTransition(
                          type: PageTransitionType.leftToRight, child: const LoginScreen()));
                    },
                    child: Text(
                      " Log In",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: PalletteColors.primaryRed,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
// widget untuk entry email
  Widget emailInput() {
    return Theme(
      child: TextField(
        onChanged: (value) {
          email = value;
        },
        controller: _text2,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          labelText: "Email ",
          errorText: _validate ? 'Email wajib diisi' : null,
          prefixIcon: const Icon(Icons.mail_outline),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.redAccent),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Colors.red,
              )),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          errorStyle: const TextStyle(fontSize: 14),
        ),
        textInputAction: TextInputAction.next,
      ),
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: PalletteColors.primaryRed),
      ),
    );
  }

  // widget untuk entry nama
  Widget nameInput() {
    return Theme(
      child: TextField(
        onChanged: (value) {
          name = value;
        },
        controller: _text1,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          labelText: "Nama",
          errorText: _validate ? 'Nama wajib diisi' : null,
          prefixIcon: const Icon(Icons.account_circle_rounded),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.redAccent),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Colors.red,
              )),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          errorStyle: const TextStyle(fontSize: 14),
        ),
        textInputAction: TextInputAction.next,
      ),
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: PalletteColors.primaryRed),
      ),
    );
  }

  // widget untuk entry password

  Widget passInput() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: PalletteColors.primaryRed),
      ),
      child: TextField(
        onChanged: (value) {
          password = value;
        },
        controller: _text3,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          prefixIcon: const Icon(
            Icons.vpn_key,
          ),
          labelText: "Password",
          errorText: _validate ? 'Password tidak boleh kosong' : null,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.redAccent),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Colors.red,
              )),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: PalletteColors.primaryGrey,
            ),
            onPressed: _toggle,
          ),
        ),
        textInputAction: TextInputAction.done,
        obscureText: _obscureText,
      ),
    );
  }
}
