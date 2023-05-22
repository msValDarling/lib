import 'package:flutter/material.dart';
import 'package:pmsna/models/nasa_model.dart';
import 'package:pmsna/widgets/item_nasa_widget.dart';

import '../network/api_nasa.dart';

class NasaScreen extends StatelessWidget {
  const NasaScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      )),
      body: FutureBuilder<List<NasaModel>?>(
        future: ApiNasa().getAlltitles(title),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al obtener los datos'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final astro = snapshot.data![index];
                return Container(
                  key: UniqueKey(),
                  padding: EdgeInsets.all(10.0),
                  child: ItemastroCard(astro: astro),
                );
              },
            );
          } else {
            return Center(
              child: Text('No se encontraron datos'),
            );
          }
        },
      ),
    );
  }
}
