import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

// 1. تعريف Observer
class MyCubitObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('Cubit/Bloc Created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('Cubit/Bloc State Changed: ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('Cubit/Bloc Error: ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('Cubit/Bloc Closed: ${bloc.runtimeType}');
  }
}
