import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen(
      {super.key, required this.movieTitle, this.movie, this.allSimilarMovies});
  final String movieTitle;
  final movie;
  final String imagePath = 'https://image.tmdb.org/t/p/w500';
  final allSimilarMovies;

  @override
  Widget build(BuildContext context) {
    print(movie);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(movieTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 320,
              child: Image.network(
                imagePath + movie['backdrop_path'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            reusableRow('Title', value: movie['original_title']),
            reusableRow('Release date', value: movie['release_date']),
            reusableRow('Language', value: movie['original_language']),
            reusableRow('Votes', value: movie['vote_count'].toString()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.white),
                  ),
                  Text(
                    movie['overview'],
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            ///
            /// Similar Movies
            //
            reusableTitle('Similar Movies'),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allSimilarMovies['results'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            print('goto movie detail screen');
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(
                                movieTitle: allSimilarMovies['results'][index]
                                    ['title'],
                                movie: allSimilarMovies['results'][index],
                                allSimilarMovies: allSimilarMovies,
                              ),
                            ));
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imagePath +
                                      allSimilarMovies['results'][index]
                                              ['backdrop_path']
                                          .toString(),
                                  width: 120,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              reusableTextWidget(
                                allSimilarMovies['results'][index]
                                    ['original_title'],
                              ),
                              reusableTextWidget(
                                allSimilarMovies['results'][index]
                                    ['release_date'],
                              ),
                              reusableTextWidget(
                                  '${allSimilarMovies['results'][index]['vote_count']} votes'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget reusableRow(String key, {String value = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 17, color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

Widget reusableTextWidget(String text) {
  return SizedBox(
    width: 120,
    child: Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    ),
  );
}

Widget reusableTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50), bottomRight: Radius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
      ),
    ),
  );
}
