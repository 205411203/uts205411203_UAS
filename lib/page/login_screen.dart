import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uts205411203/movie/pages/home/home.dart';
import 'package:uts205411203/component/color.dart';
import 'package:uts205411203/page/registration_page.dart';
import 'package:uts205411203/widget/tabbutton_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../movie/pages/home/home.dart';

//Halaman Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool showSpinner = false;
  late String password;
  late String email;

  //koneksi validasi ke Firebase Auth Google

  // final _firestore = Firestore.
  final _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool _validate = false;
  final _text1 = TextEditingController();
  final _text2 = TextEditingController();


  @override
  void dispose() {
    _text1.dispose();
    _text2.dispose();
    // _text3.dispose();
    super.dispose();
  }

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
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
          title: const Text("Login Pustaka Film"),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          elevation: 3.0,
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 50.0,
              ),
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 150.0,
                  child: Image.asset('assets/movies.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
                child: emailInput(),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
                child: passInput(),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Hero(
                  tag: "button2",
                  child: TabButton(
                    btnColor: PalletteColors.primaryRed,
                    btnTxtColor: Colors.white,
                    btnText: "Log In",
                    btnFunction: () async {
                      _text1.text.isEmpty ? _validate = false : _validate = true;
                      _text2.text.isEmpty ? _validate = false : _validate = true;
                      setState((){
                        // showSpinner = true;
                      });

                      //jika email dan password sesuai dengan data firebase, lanjut pada home_page

                      try{
                        UserCredential loggedInUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => Home()));
                          setState(() {
                            // showSpinner = false;
                          });
                          return loggedInUser;
                      }on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          // ignore_for_file: avoid_print
                          Fluttertoast.showToast(
                              msg: "Email belum terdaftar",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                        } else if (e.code == 'wrong-password') {
                          Fluttertoast.showToast(
                              msg: "Password salah",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                      }

                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Hero(
                  tag: "button3",
                  child: TabButton(
                    btnColor: PalletteColors.primaryRed,
                    btnTxtColor: Colors.white,
                    btnText: "Register",
                    btnFunction: () async {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => RegistrationPage()));
                      setState((){
                        // showSpinner = true;
                      });

                    },
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  // widget untuk entry field email
  Widget emailInput() {
    return Theme(
      data: Theme.of(context)
          .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: PalletteColors.primaryRed),),
      child: TextField(
        onChanged: (value){
          email = value;
        },
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),

        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          hintText: 'Masukkan alamat email',
          labelText: "Email ID",
          errorText: _validate ? 'Email harus diisi' : null,
          prefixIcon: const Icon(Icons.mail_outline),
          labelStyle: const TextStyle(fontSize: 16,color: Colors.redAccent),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          errorStyle: const TextStyle(fontSize: 14),
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
              )
          ),
        )
        ,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  // widget untuk entry field password

  Widget passInput() {

    return Theme(
      data: Theme.of(context)
          .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: PalletteColors.primaryRed),),
      child: TextField(
        onChanged: (value){
          password = value;
        },
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          hintText: 'Masukkan password',
          prefixIcon: const Icon(Icons.vpn_key,),
          labelText: "Password",
          errorText: _validate ? 'Password harus diisi' : null,
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
              )
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          errorStyle: const TextStyle(fontSize: 14),
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
