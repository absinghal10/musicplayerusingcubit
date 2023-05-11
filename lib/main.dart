import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayerusingcubit/cubit/audioplayer/AudioPlayerCubit.dart';
import 'package:musicplayerusingcubit/cubit/connectivity/connectivity_cubit.dart';
import 'package:musicplayerusingcubit/cubit/musicdata/MyCubit.dart';

import 'screens/HomePage.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityCubit>(
          create: (BuildContext context) => ConnectivityCubit(),
        ),
        BlocProvider<MyCubit>(
          create: (BuildContext context) => MyCubit(),
        ),
        BlocProvider<AudioPlayerCubit>(
          create: (BuildContext context) => AudioPlayerCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        title: "Home Page",
        home: HomePage(),
      )
    );


  }
}