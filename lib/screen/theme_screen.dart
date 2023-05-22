import 'package:flutter/material.dart';
import 'package:pmsna/provider/theme_provider.dart';
import 'package:pmsna/settings/styles_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme_provider tema = Provider.of<Theme_provider>(context);

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              opacity: .5,
              fit: BoxFit.cover,
              image: AssetImage('assets/fondoLince.png'))),
      child: Scaffold(
        body: Center(
          child: Column(children: [
            TextButton.icon(
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.setString('theme', 'dia');
                tema.setthemeData(ThemeData.light());
              },
              icon: Icon(Icons.brightness_1),
              label: Text('Tema de Día'),
            ),
            TextButton.icon(
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.setString('theme', 'noche');
                tema.setthemeData(ThemeData.dark());
              },
              icon: Icon(Icons.dark_mode),
              label: Text('Tema de Noche'),
            ),
            TextButton.icon(
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.setString('theme', 'calido');
                tema.setthemeData(ThemeData.light());
              },
              icon: Icon(Icons.hot_tub_sharp),
              label: Text('Tema Cálido'),
            ),
          ]),
        ),
      ),
    );
  }
}
