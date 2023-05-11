import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayerusingcubit/model/MusicDataResponse.dart';

import '../cubit/audioplayer/AudioPlayerCubit.dart';
import '../cubit/audioplayer/AudioPlayerState.dart';

class MusicDetailScreen extends StatefulWidget {
  final MusicDataResponse response;

  const MusicDetailScreen({Key? key, required this.response}) : super(key: key);

  @override
  State<MusicDetailScreen> createState() => _MusicDetailScreenState();
}

class _MusicDetailScreenState extends State<MusicDetailScreen> {


  @override
  void initState() {
    BlocProvider.of<AudioPlayerCubit>(context).pause();
    BlocProvider.of<AudioPlayerCubit>(context).seekTo(Duration(seconds: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration.zero;
    Duration position = Duration.zero;
    bool isPlaying = false;
    late int seconds;
    seconds = widget.response.duration!.toInt();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Music Detail Page"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2.75,
                  widget.response.image.toString(),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 32,),
              Text(
                widget.response.title.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4,),
              Text(widget.response.artist.toString(),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              BlocListener<AudioPlayerCubit, AudioPlayerState>(
                listener: (context, state) {
                  if (state is AudioPlayerDurationChanged) {
                    duration = state.duration;
                  }

                  if (state is AudioPlayerPositionChanged) {
                    position = state.position;
                  }
                },
                child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                  builder: (context, state) {
                    return Slider(
                        value: position.inSeconds.toDouble(),
                        min: 0.0,
                        activeColor: Colors.white,
                        max: seconds.toDouble(),
                        onChanged: (value) {
                          print("value:" + value.toString());
                          final position = Duration(seconds: value.toInt());
                          print("Postion:" + position.toString());
                          context.read<AudioPlayerCubit>().seekTo(position);
                        });
                  },
                ),
              ),
              BlocListener<AudioPlayerCubit, AudioPlayerState>(
                listener: (context, state) {

                },
                child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(position)),
                          Text((state is AudioPlayerPositionChanged) ? formatTime(
                              duration - position) : formatTime(
                              Duration(seconds: seconds))),
                        ],
                      ),
                    );
                  },
                ),
              ),
              CircleAvatar(
                  radius: 35,
                  child: BlocListener<AudioPlayerCubit, AudioPlayerState>(
                    listener: (context, state) {
                      if (state is AudioPlayerPositionChanged) {
                        if (seconds == state.position.inSeconds.toInt()) {
                          debugPrint("playing value");
                          isPlaying = false;
                        }
                      }
                      if (state is AudioPlayerPlaying) {
                        isPlaying = state.playing;
                        print("isPlaying:"+isPlaying.toString());
                      }
                    },
                    child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                      builder: (context, state) {
                        return IconButton(
                          onPressed: () {

                            if (isPlaying) {
                              context.read<AudioPlayerCubit>().pause();
                            }
                            else {
                              context.read<AudioPlayerCubit>().play(
                                  widget.response.source.toString());
                            }
                          },
                          icon: Icon(isPlaying ? Icons.pause : Icons
                              .play_arrow),
                          iconSize: 50,
                        );
                      },
                    ),
                  )

              ),
            ],
          ),
        )

    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if(duration.inHours > 0)hours,
      twoDigitMinutes,
      twoDigitSeconds
    ].join(':');
  }
}
