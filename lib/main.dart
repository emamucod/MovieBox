import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async'; // Import async library for Timer
import 'search_screen.dart';
import 'dart:convert';
import 'dart:math'; // Import the 'dart:math' library for Random

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar Example',
      home: MyHomePage(),
      routes: {
        '/search': (context) => SearchScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchQuery = '';

  Future<void> getMovieData(String query) async {
    try {
      String data = '';
      String poster = '';
      String overview = '';
      String date = '';
      Uri url = Uri.parse('https://api.themoviedb.org/3/search/movie?query=$query&api_key=0b2c17bd523fc6b5e5b4e21971a8d2c6');
      Response response = await get(url);
      data = response.body;

      // Check if there are results before accessing them
      if (jsonDecode(data)['results'] != null && jsonDecode(data)['results'].isNotEmpty) {
        poster = jsonDecode(data)['results'][0]['poster_path'];
        overview = jsonDecode(data)['results'][0]['overview'];
        date = jsonDecode(data)['results'][0]['release_date'];
        print(data);
        print(poster);
        print(overview);
        print(date);
      } else {
        print('No results found');
      }
    } catch (error) {
      print('Error fetching movie data: $error');
    }
  }

  Future<void> navigateToSearchScreen(String query) async {
    try {
      await getMovieData(query); // Call getMovieData before navigating

      Map<String, dynamic> searchData = {
        'searchQuery': query,
        // add more data as needed
      };

      Navigator.pushNamed(
        context,
        '/search',
        arguments: jsonEncode(searchData),
      );
    } catch (error) {
      print('Error navigating to search screen: $error');
    }
  }

  String generateRandomWord() {
    // List of sample words
    List<String> words = [
      'Apple', 'Banana', 'Orange', 'Strawberry', 'Kiwi', 'Watermelon',
      'Giraffe', 'Elephant', 'Lion', 'Tiger', 'Zebra', 'Monkey',
      'Mountain', 'Ocean', 'Forest', 'Desert', 'Canyon', 'Island',
      'Guitar', 'Piano', 'Violin', 'Drums', 'Trumpet', 'Flute',
      'Computer', 'Phone', 'Tablet', 'Keyboard', 'Mouse', 'Monitor',
      'Titan','It','Spit','Kiss','Smile','Love','Pursuit','Gods','Troy',
      'Castle','Hotel','My','Hallow','Christmas','Holiday','Game','Dead',
      'Salt','Punisher','Zombading','The Hows of Us','Kita Kita','Sukob'
    ];

    // Generate a random index
    int randomIndex = Random().nextInt(words.length);

    // Return the random word
    return words[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Box'),
        backgroundColor: Colors.black54,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BGImage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    labelText: 'Enter movie title',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: 200.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        navigateToSearchScreen(searchQuery);
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward, size: 40.0, color: Colors.white),
                        const SizedBox(width: 8.0),
                        Text('Search', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: 200.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.green, // Change the color as needed
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        String randomQuery = generateRandomWord();
                        navigateToSearchScreen(randomQuery);
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.casino, size: 40.0, color: Colors.white),
                        const SizedBox(width: 8.0),
                        Text('Random Search', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
