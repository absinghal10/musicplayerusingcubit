import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AudioPlayerState.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  AudioPlayerCubit() : super(AudioPlayerInitial()){

    // listen to audio duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      emit(AudioPlayerDurationChanged(duration: newDuration));
    });

    // listen to audio position
    _durationSubscription=_positionSubscription=_audioPlayer.onPositionChanged.listen((newPosition) {
      emit(AudioPlayerPositionChanged(position: newPosition));
    });

  }

  Future<void> play(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
      isPlaying = true;
      emit(AudioPlayerPlaying(playing:isPlaying));
    } catch (e) {
      emit(AudioPlayerError());
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      isPlaying = false;
      emit(AudioPlayerPlaying(playing:isPlaying));
    } catch (e) {
      emit(AudioPlayerError());
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      emit(AudioPlayerStopped());
    } catch (e) {
      emit(AudioPlayerError());
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      emit(AudioPlayerDurationChanged(duration: position));
    } catch (e) {
      emit(AudioPlayerError());
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    return super.close();
  }
}
