import 'package:flutter/material.dart';
import 'package:pmsna/models/popular_model.dart';
import 'package:pmsna/widgets/movie_trailer.dart';

class BackdropTrailer extends StatelessWidget {
  const BackdropTrailer({Key? key, required this.popularModel});

  final PopularModel popularModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.4,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.4 - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500/${popularModel.backdropPath}',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.2,
            left: size.width * 0.5 - 36,
            child: Container(
              width: 72,
              height: 72,
              child: FloatingActionButton(
                elevation: 10,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieTrailer(popularModel: popularModel),
                    ),
                  );
                },
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
