import 'package:flutter/material.dart';
import 'package:pmsna/models/popular_model.dart';
import 'package:pmsna/network/api_popular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailer extends StatelessWidget {
  MovieTrailer({super.key, required this.popularModel});

  final PopularModel popularModel;
  ApiPopular apiPopular = ApiPopular();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: apiPopular.getTrailer(popularModel.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final trailer = snapshot.data!;
            return YoutubePlayer(
              controller: YoutubePlayerController(
                  initialVideoId: trailer['key'],
                  flags: YoutubePlayerFlags(
                      autoPlay: true,
                      mute: false,
                      controlsVisibleAtStart: true)),
              aspectRatio: 16 / 9,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
