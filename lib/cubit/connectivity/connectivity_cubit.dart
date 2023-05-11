import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {

  final Connectivity _connectivity=Connectivity();

  StreamSubscription? _connectivitySubscription;

  ConnectivityCubit() : super(ConnectivityInitial()){
    checkNetworkConnectivity();
  }

  void checkNetworkConnectivity(){

    _connectivity.onConnectivityChanged.listen((result) {
      if(result==ConnectivityResult.mobile||result==ConnectivityResult.wifi){
        emit(ConnectivityGained("Network Connected"));
      }else{
        emit(ConnectivityLost("Network not Connected"));
      }
    });
  }



  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

}
