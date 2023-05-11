abstract class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerPlaying extends AudioPlayerState {
  final bool playing;
  AudioPlayerPlaying({required this.playing});
}


class AudioPlayerStopped extends AudioPlayerState {}

class AudioPlayerError extends AudioPlayerState {}

class AudioPlayerDurationChanged extends AudioPlayerState {
  final Duration duration;
  AudioPlayerDurationChanged({required this.duration});
}

class AudioPlayerPositionChanged extends AudioPlayerState {
  final Duration position;
  AudioPlayerPositionChanged({required this.position});
}


