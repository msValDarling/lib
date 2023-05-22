import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmsna/models/popular_model.dart';
import 'package:pmsna/models/actors_movie.dart';

class ApiPopular {
  Uri link = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=a312589363702724132147d44222494f&language=es-MX&page=1');

  Future<List<PopularModel>?> getAllPopular() async {
    var result = await http.get(link);
    var listJSON = jsonDecode(result.body)['results'] as List;
    if (result.statusCode == 200) {
      return listJSON.map((popular) => PopularModel.fromMap(popular)).toList();
    }
    return null;
  }

  Future<Map<String, dynamic>> getTrailer(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=a312589363702724132147d44222494f'),
    );

    final data = jsonDecode(response.body);
    final trailer = data['results'].firstWhere(
      (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
      orElse: () => null,
    );

    return trailer;
  }

  Future<List<ActorsMovie>?> getAllAuthors(PopularModel popularModel) async {
    Uri actores = Uri.parse(
        'https://api.themoviedb.org/3/movie/${popularModel.id.toString()}/credits?api_key=a312589363702724132147d44222494f');
    var result = await http.get(actores);
    if (result.statusCode == 200) {
      var listJSON = jsonDecode(result.body)['cast'] as List;
      return listJSON.map((actor) => ActorsMovie.fromMap(actor)).toList();
    }
    return null;
  }
}
