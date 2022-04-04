import 'package:flutter/material.dart';
import 'package:uts205411203/page/login_screen.dart';
import 'package:uts205411203/page/registration_page.dart';
import 'package:uts205411203/component/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uts205411203/widget/tabbutton_widget.dart';

//Halaman awal untuk transisi login/register

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static String id = 'welcome_page';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animationcurve;

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = AnimationController(
        duration: const Duration(seconds: 5),
        vsync: this,

      );
      animationcurve =
          CurvedAnimation(parent: controller, curve: Curves.decelerate);
      controller.forward();

      controller.addListener(() {
        setState(() {

        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              //button untuk menuju halaman registrasi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Hero(
                  tag: "button",
                  child: TabButton(
                    btnColor: PalletteColors.primaryRed,
                    btnTxtColor: Colors.white,
                    btnText: "Buat Akun Baru",

                    btnFunction: () {
                      Navigator.push(context, PageTransition(
                          type: PageTransitionType.fade,
                          child: const RegistrationPage()));
                    },
                  ),
                ),
              ),
              //button untuk menuju halaman login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Hero(
                  tag: "button2",
                  child: TabButton(
                    btnColor: PalletteColors.lightBlue,
                    btnTxtColor: Colors.black,
                    btnText: "Login dengan Email",

                    btnFunction: () {
                      Navigator.push(context, PageTransition(
                          type: PageTransitionType.leftToRight, child: const LoginScreen()));
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 28.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: Text(
                        "©2022",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.yellow, fontSize: 10.0),
                        )
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


}
