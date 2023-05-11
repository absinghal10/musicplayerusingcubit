import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayerusingcubit/cubit/connectivity/connectivity_cubit.dart';
import 'package:musicplayerusingcubit/cubit/musicdata/MyCubit.dart';
import 'package:musicplayerusingcubit/cubit/musicdata/MyCubitState.dart';
import 'package:musicplayerusingcubit/screens/MusicDetailScreen.dart';

import '../model/MusicDataResponse.dart';
import 'MusicDetailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MusicDataResponse> musicList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Music App"),
          centerTitle: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),
        body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, state) {
            if (state is ConnectivityGained) {
              return BlocBuilder<MyCubit, MyCubitState>(
                builder: (context, state) {
                  if (state is MyCubitLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MyCubitSuccess) {
                    musicList = state.data;
                    return customListCard();
                  } else if (state is MyCubitError) {
                    return Center(child: Text(state.errorMessage.toString()));
                  } else {
                    return const Center(child: Text("Heelo"));
                  }
                },
              );
            } else if (state is ConnectivityLost) {
              return const Center(child: Text("Please Connect network"));
            }

            return const Text("ksdd");
          },
        ));
  }

  Widget customListCard() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MusicDetailScreen(response: musicList[index]),
                ));
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, bottom: 8, right: 8, top: 4),
                  child: SizedBox(
                    child: FadeInImage.assetNetwork(
                        height: 60,
                        width: 60,
                        placeholder: "lib/assets/images/musicplaceholder.png",
                        image: musicList[index].image.toString(),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicList[index].title.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      musicList[index].artist.toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: musicList.length,
    );
  }
}
