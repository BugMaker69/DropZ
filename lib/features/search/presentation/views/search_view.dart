import 'package:drop_z_ecommerce_app/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            context.read<SearchCubit>().search(value);
          },
          decoration: const InputDecoration(
            hintText: "ابحث هنا...",
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // يرجع للصفحة السابقة
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(child: Text("🔍 اكتب كلمة للبحث"));
          } else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded) {
            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(state.results[index]),
                );
              },
            );
          } else {
            return const Center(child: Text("Error"));
          }
        },
      ),
    );
  }
}
