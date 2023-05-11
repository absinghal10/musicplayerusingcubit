part of 'connectivity_cubit.dart';

@immutable
abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityGained extends ConnectivityState {
  final String connectivityMessage;
  ConnectivityGained(this.connectivityMessage);
}

class ConnectivityLost extends ConnectivityState {
  final String connectivityMessage;
  ConnectivityLost(this.connectivityMessage);
}

