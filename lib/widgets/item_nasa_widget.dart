import 'package:flutter/material.dart';
import 'package:pmsna/models/nasa_model.dart';

import '../screen/nasa_detail_screen.dart';

class ItemastroCard extends StatelessWidget {
  const ItemastroCard({super.key, required this.astro});

  final NasaModel astro;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
            height: 150.0,
            child: Text(
              astro.title!,
              style: TextStyle(fontFamily: 'Times New Roman'),
            )),
        SizedBox(
          height: 8.0,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => astroDetailScreen(nasaobj: astro),
              ));
            },
            child: Text('Ver detalles',
                style: Theme.of(context).textTheme.bodyMedium),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ))
      ]),
    );
  }
}
