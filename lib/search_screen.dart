import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:movie_app/movie.dart'; // Assuming this is the correct import path
import 'package:movie_app/main.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the searchQuery data from the arguments
    String? searchDataJson =
    ModalRoute.of(context)?.settings.arguments as String?;
    Map<String, dynamic> searchData = jsonDecode(searchDataJson ?? '{}');
    String searchQuery = searchData['searchQuery'] ?? '';

    // Fetch movies
    Movies movies = Movies();
    Future<Map<String, dynamic>> movieData = movies.getMovies(searchQuery);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Set AppBar background color to orange
        title: Text('Search Results'),
      ),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Column(
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: movieData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    String posterPath = snapshot.data?['poster'] ?? '';
                    String overview = snapshot.data?['overview'] ?? '';
                    String date = snapshot.data?['date'] ?? '';
                    String imageUrl =
                        'https://www.themoviedb.org/t/p/w300_and_h450_bestv2$posterPath';
                    return Column(
                      children: [
                        // Image on the left with smooth corners
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              imageUrl,
                              width: 100,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Textbox beside the image
                        Container(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Search Results for: $searchQuery',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView(
                                  children: [
                                    Text(
                                      'Overview: $overview',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple, // Set ElevatedButton background color to orange
                ),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
