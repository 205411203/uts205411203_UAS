import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:uts205411203/page/welcome_page.dart';

//Menampilkan on Boarding Page
class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Membaca Buku Membuka Jendela Dunia',
          body: 'Cakrawala Ilmu Tak Terbatas',
          image: buildImage('assets/ebook.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Teknologi dan Buku',
          body: 'Pelajari teknologi lewat buku',
          image: buildImage('assets/readingbook.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Ayo membaca',
          body: 'Dapatkan pengalaman berharga',
          image: buildImage('assets/manthumbs.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Today a reader, tomorrow a leader',
          body: 'Start your journey',
          image: buildImage('assets/learn.png'),
          decoration: getPageDecoration(),
        ),
      ],
      done: const Text('Lihat', style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: const Text('Lewati'),
      onSkip: () => goToHome(context),
      next: const Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: Theme.of(context).primaryColor,
      // isProgressTap: false,
      // isProgress: false,
      // showNextButton: false,
      // freeze: true,
      // animationDuration: 1000,
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => WelcomePage()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: const Color(0xFFBDBDBD),
    //activeColor: Colors.orange,
    size: const Size(10, 10),
    activeSize: const Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: const TextStyle(fontSize: 20),
    bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: const EdgeInsets.all(24),
    pageColor: Colors.white,
  );
}