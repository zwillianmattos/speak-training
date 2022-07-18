abstract class VoiceState {}

class RecordVoiceState implements VoiceState {
  final String recognizedWords;
  RecordVoiceState(this.recognizedWords);
}

class StopVoiceState extends VoiceState {
  final String recognizedWords;
  StopVoiceState(this.recognizedWords);
}

class ResultVoiceState extends StopVoiceState {
  ResultVoiceState(super.recognizedWords);
}

class RecordingVoiceState extends VoiceState {}

class LoadingVoiceState extends VoiceState {}

class ErrorVoiceState extends VoiceState {
  final String message;
  ErrorVoiceState(this.message);
}
