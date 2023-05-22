import 'package:concentric_transition/page_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pmsna/screen/card_lince.dart';
import 'package:pmsna/screen/login_screen.dart';
import 'package:pmsna/responsive.dart';

//---------------Onboarding
class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        itemBuilder: (int index) {
          return Container(
              alignment: Alignment.center, child: CardLince(data: data[index]));
        },
        onFinish: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      ),
    );
  }
}

//---------------Onboarding CARDS
final data = [
  CardLinceData(
      title: "Lince Social App :D",
      subtitle:
          "Manténte al tanto de las últimas linceNovedades que ocurren dentro de campus II,"
          " esta App está diseñada para que alumnos del Tec de Celaya interactúen entre sí, "
          "compartan experiencias, novedades y eventos :)",
      image: AssetImage('assets/linx.png'),
      backgroundColor: Color.fromARGB(206, 177, 117, 67),
      titleColor: Color.fromARGB(255, 36, 20, 5),
      subtitleColor: Color.fromARGB(255, 53, 38, 38),
      background: LottieBuilder.asset('assets/fon3.json')),
  CardLinceData(
      title: "Desarrollada por...",
      subtitle:
          "Esta App fue diseñada por alumnos de la carrera de Ingeniería en Sistemas "
          "Computacionales, a la vanguardia de Industria 4.0 y las nuevas Tecnologías "
          "innovando procesos y el desarrollo de soluciones de software en la Era Digital :)",
      image: AssetImage('assets/yo.png'),
      backgroundColor: Color.fromARGB(230, 49, 105, 32),
      titleColor: Color.fromARGB(255, 53, 38, 38),
      subtitleColor: Color.fromARGB(255, 53, 38, 38),
      background: LottieBuilder.asset('assets/fon3.json')),
  CardLinceData(
      title: "Diviértete en actividades recreativas",
      subtitle:
          "Explora y descubre todas las actividades extraescolares a las que te"
          " puedes inscribir, desde deportivas hasta culturales y lo mejor es que puedes"
          " asistir a más de una! Te recomendamos inspirarte de los mejores como Assasin Baby!",
      image: AssetImage('assets/baby.png'),
      backgroundColor: Color.fromARGB(210, 11, 103, 139),
      titleColor: Color.fromARGB(255, 53, 38, 38),
      subtitleColor: Color.fromARGB(255, 53, 38, 38),
      background: LottieBuilder.asset('assets/fon3.json'))
];
