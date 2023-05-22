import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pmsna/models/nasa_model.dart';

class ApiNasa {
  Uri link = Uri.parse(
      'https://api.nasa.gov/planetary/apod?api_key=qXS6Wc936Mmak0LHORI0z9wOU9R3RKpTnOiLScyi');

  Future<List<NasaModel>?> getAllPopular() async {
    var result = await http.get(link);
    var listJSON = jsonDecode(result.body)['results'] as List;
    if (result.statusCode == 200) {
      return listJSON.map((popular) => NasaModel.fromMap(popular)).toList();
    }
    return null;
  }

  Future<List<NasaModel>?> getAlltitles(String title) async {
    Uri titulos = Uri.parse(
        'https://api.themoviedb.org/3/movie/${title.toString()}/credits?api_key=a312589363702724132147d44222494f');
    var result = await http.get(titulos);
    if (result.statusCode == 200) {
      var listJSON = jsonDecode(result.body)['titulo'] as List;
      return listJSON.map((titulo) => NasaModel.fromMap(titulo)).toList();
    }
    return null;
  }
}
