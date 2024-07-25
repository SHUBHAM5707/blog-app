import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionCheaker{
  Future<bool> get isConnected;
}

class ConnectionCheakerImpl implements ConnectionCheaker{
  final InternetConnection internetConnection;
  ConnectionCheakerImpl(this.internetConnection);
  @override
  Future<bool> get isConnected async => await internetConnection.hasInternetAccess;

}