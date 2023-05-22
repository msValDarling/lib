import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pmsna/database/database_helper.dart';
import 'package:pmsna/models/popular_model.dart';
import 'package:pmsna/network/api_popular.dart';
import 'package:pmsna/provider/flags_provider.dart';
import 'package:pmsna/responsive.dart';
import 'package:pmsna/models/actors_movie.dart';
import 'package:pmsna/widgets/backdrop_trailer.dart';
import 'package:provider/provider.dart';

class MovieDetails extends StatelessWidget {
  MovieDetails({required this.popularModel, this.updateFavsMovies, super.key});

  final PopularModel popularModel;
  final Function? updateFavsMovies;

  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    return Scaffold(
      body: detailBody(context, flag),
    );
  }

  ApiPopular apiPopular = ApiPopular();

  Widget detailBody(BuildContext context, FlagsProvider flag) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500/${popularModel.posterPath}'),
                          fit: BoxFit.cover,
                          opacity: 0.3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BackdropTrailer(popularModel: popularModel),
                      Center(
                        child: Text(
                          '${popularModel.title}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      RatingStars(
                        rating: popularModel.voteAverage!,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                'Sinopsis',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 10),
                              Text(
                                popularModel.overview!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Actores',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              FutureBuilder<List<ActorsMovie>?>(
                                future: apiPopular.getAllAuthors(popularModel),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          ActorsMovie actorsMovie =
                                              snapshot.data![index];
                                          return ActorInfo(
                                            name: actorsMovie.name!,
                                            photoUrl:
                                                'https://image.tmdb.org/t/p/original/${actorsMovie.profilePath}',
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        detailAppbar(context, flag),
      ],
    );
  }

  Widget detailAppbar(BuildContext context, FlagsProvider flag) {
    return Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: Container(
            padding: EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 16.0),
              child: FutureBuilder(
                future: databaseHelper.searchMovie(popularModel.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                      onPressed: () {
                        if (snapshot.data != true) {
                          databaseHelper
                              .INSERT('tblMoviesFavs', popularModel.toMap())
                              .then((value) => flag.setflagListPost());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Película agregada a favoritos')),
                          );
                        } else {
                          databaseHelper
                              .DELETE('tblMoviesFavs', popularModel.id!, 'id')
                              .then((value) => flag.setflagListPost());
                          if (updateFavsMovies != null) {
                            updateFavsMovies!();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Película eliminada de favoritos')),
                          );
                        }
                      },
                      icon: Icon(Icons.favorite),
                      color: Theme.of(context).iconTheme.color,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}

class ActorInfo extends StatelessWidget {
  final String name;
  final String photoUrl;

  const ActorInfo({
    Key? key,
    required this.name,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          ClipOval(
              child: photoUrl.endsWith("null")
                  ? Image.asset('assets/actor_default.png',
                      width: 70, height: 85, fit: BoxFit.fill)
                  : FadeInImage(
                      width: 70,
                      height: 85,
                      fit: BoxFit.fill,
                      placeholder: const AssetImage('assets/actor_default.png'),
                      image: NetworkImage(photoUrl),
                    )),
          SizedBox(height: 10),
          Text(name, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color starColor;

  const RatingStars({
    Key? key,
    required this.rating,
    this.starSize = 30.0,
    this.starColor = Colors.yellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildStar(1),
            _buildStar(2),
            _buildStar(3),
            _buildStar(4),
            _buildStar(5),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          rating.toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildStar(int index) {
    IconData iconData = Icons.star_border;
    Color iconColor = Colors.grey.shade400;

    if (index <= rating) {
      iconData = Icons.star;
      iconColor = starColor;
    } else if (index - rating <= 0.5) {
      iconData = Icons.star_half;
      iconColor = starColor;
    }

    return Icon(
      iconData,
      size: starSize,
      color: iconColor,
    );
  }
}
