import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../model/MusicDataResponse.dart';
import 'MyCubitState.dart';

class MyCubit extends Cubit<MyCubitState> {
  MyCubit() : super(MyCubitInitial()){
    getAllFetchMusicData();
  }


  Future<void> getAllFetchMusicData()async {
    const url = "https://storage.googleapis.com/uamp/catalog.json";
    Uri uri = Uri.parse(url);
    emit(MyCubitLoading());
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {

        final body=response.body;
        final json=jsonDecode(body);
        final result=json['music'] as List<dynamic>;
        final musicList=result.map( (e) {
          return MusicDataResponse.fromJson(e);
        }).toList();

        emit(MyCubitSuccess(musicList));

        debugPrint(response.body.toString());

      } else {
        emit(MyCubitError('Failed to fetch data${response.statusCode}'));
      }
    } catch (e) {
      print(e);
      emit(MyCubitError('An error occurred$e'));
    }
  }


}
