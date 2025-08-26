import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final List<String> allItems = [
    "Apple",
    "Banana",
    "Orange",
    "Mango",
    "Pineapple",
    "Car",
    "Bike",
    "Bus",
    "Flutter",
    "Dart",
  ];

  void search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    // simulate delay (زي لما تستدعي API)
    await Future.delayed(const Duration(milliseconds: 500));

    final filtered = allItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(SearchLoaded(filtered));
  }
}
