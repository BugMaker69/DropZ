import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit() : super(NetworkInitial()) {
    _startListening();
  }

  void _startListening() async {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        emit(NetworkDisconnected());
      } else {
        final hasInternet = await InternetConnectionChecker().hasConnection;
        emit(hasInternet ? NetworkConnected() : NetworkWeak());
      }
    });

    // أول تشغيل
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      emit(NetworkDisconnected());
    } else {
      final hasInternet = await InternetConnectionChecker().hasConnection;
      emit(hasInternet ? NetworkConnected() : NetworkWeak());
    }
  }

  // دالة لإعادة المحاولة
  Future<void> retry() async => _startListening();
}
