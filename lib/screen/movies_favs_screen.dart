import 'package:flutter/material.dart';
import 'package:pmsna/database/database_helper.dart';
import 'package:pmsna/models/popular_model.dart';
import 'package:pmsna/provider/flags_provider.dart';
import 'package:pmsna/widgets/item_popular.dart';
import 'package:provider/provider.dart';
import 'movie_datails_screen.dart';

class MoviesFavsScreen extends StatefulWidget {
  const MoviesFavsScreen({super.key});

  @override
  State<MoviesFavsScreen> createState() => _MoviesFavsScreenState();
}

class _MoviesFavsScreenState extends State<MoviesFavsScreen> {
  late Future<List<PopularModel>> _favsMovies;

  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    listMoviesFavs();
  }

  Future<void> listMoviesFavs() async {
    final databaseHelper = DatabaseHelper();
    _favsMovies = databaseHelper.getAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Favorite Movies',
        style: Theme.of(context).textTheme.titleLarge,
      )),
      body: FutureBuilder(
          future: _favsMovies,
          builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Hero(
                        tag: snapshot.data![index],
                        child:
                            ItemPopular(popularModel: snapshot.data![index])),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetails(
                                popularModel: snapshot.data![index],
                                updateFavsMovies: updateFavsMovies),
                          ));
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Ocurrio un error'),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Future<void> updateFavsMovies() async {
    setState(() {
      _favsMovies = databaseHelper.getAllMovies();
    });
  }
}
