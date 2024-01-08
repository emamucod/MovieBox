import 'dart:convert';

import 'package:http/http.dart';

class Movies {
  Future<Map<String, dynamic>> getMovies(String searchQuery) async {
    String data = '';
    String poster = '';
    String overview = '';
    String date = '';

    Uri url = Uri.parse('https://api.themoviedb.org/3/search/movie?query=$searchQuery&api_key=0b2c17bd523fc6b5e5b4e21971a8d2c6');
    Response response = await get(url);

    data = response.body;
    if (jsonDecode(data)['results'].isNotEmpty) {
      poster = jsonDecode(data)['results'][0]['poster_path'];
      overview = jsonDecode(data)['results'][0]['overview'];
    }

    print(data);
    print(poster);
    print(overview);

    return {
      'data': data,
      'poster': poster,
      'overview': overview,
      'date' : date,
    };
  }
}