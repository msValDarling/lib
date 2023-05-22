import 'package:flutter/material.dart';
import 'package:pmsna/models/popular_model.dart';

class ItemPopular extends StatelessWidget {
  ItemPopular({super.key, required this.popularModel});
  PopularModel? popularModel;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      fit: BoxFit.fill,
      placeholder: const AssetImage('assets/F.gif'),
      image: NetworkImage(
          'https://image.tmdb.org/t/p/w500/${popularModel!.posterPath}'),
    );
  }
}
