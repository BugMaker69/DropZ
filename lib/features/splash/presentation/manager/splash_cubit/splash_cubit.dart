import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.preferences) : super(SplashInitial());

  final SharedPreferences preferences;

  Future<void> checkAuth() async {
    emit(SplashLoading());

    final token = preferences.getString("accessToken");

    await Future.delayed(const Duration(seconds: 2)); // تأخير بسيط

    if (token != null && token.isNotEmpty) {
      emit(SplashAuthenticated()); // فيه توكن → خش على البروفايل
    } else {
      emit(SplashUnauthenticated()); // مفيش → روح للوجين
    }
  }
}
