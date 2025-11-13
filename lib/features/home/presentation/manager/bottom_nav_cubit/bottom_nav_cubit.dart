import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_state.dart';

// class BottomNavCubit extends Cubit<BottomNavState> {
//   BottomNavCubit() : super(BottomNavState(index: 0));

//     void changeTab(int newIndex) {
//     emit(BottomNavState(index: newIndex));
//   }
// }

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void changeTab(int index) => emit(index);
}
