import 'package:musicplayerusingcubit/model/MusicDataResponse.dart';

abstract class MyCubitState {}

class MyCubitInitial extends MyCubitState {}

class MyCubitLoading extends MyCubitState {}

class MyCubitSuccess extends MyCubitState {
  List<MusicDataResponse> data = [];

  MyCubitSuccess(data) {
    this.data = data;
  }
}

class MyCubitError extends MyCubitState {
  final String errorMessage;

  MyCubitError(this.errorMessage);
}
