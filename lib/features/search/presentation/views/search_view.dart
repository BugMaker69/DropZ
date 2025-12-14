import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // عشان نتحكم احنا في الباك
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // لو النظام رجّع فعلاً مانعملش حاجة

        FocusScope.of(context).unfocus();

        await Future.delayed(const Duration(milliseconds: 80), () {
          if (context.canPop()) {
            Navigator.pop(context);
          } else {
            SystemNavigator.pop();
            // exit(0);
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            controller: _controller,
            autofocus: true,
            onChanged: (value) {
              context.read<SearchCubit>().search(value);
            },
            decoration: const InputDecoration(
              hintText: "ابحث هنا...",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _controller.clear();
                context.read<SearchCubit>().search("");
                // FocusScope.of(context).unfocus();

                // Future.delayed(Duration(milliseconds: 80), () {
                //   if (context.canPop()) {
                //     Navigator.pop(context);
                //   }
                // }
                // );
              },
            ),
          ],
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial) {
              return const CustomErrorWidget(errMessage: "🔍 اكتب كلمة للبحث");
            } else if (state is SearchLoading) {
              return CustomLoadingIndicator();
            } else if (state is SearchSuccess) {
              if (state.results.results!.isEmpty) {
                return const CustomErrorWidget(errMessage: "لا توجد نتائج");
              }
              return ListView.builder(
                itemCount: state.results.results!.length,
                itemBuilder: (_, index) {
                  final product = state.results.results![index];
                  return ListTile(
                    leading: const Icon(Icons.search),
                    title: Text("${product.title}"),
                    subtitle: Text("Price: ${product.price} EGP"),
                    onTap: () {
                      context.push(
                        AppRouter.kSearchResultsView,
                        extra: {
                          "query": product.title,
                          "products": state.results,
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return const CustomErrorWidget(errMessage: "Error");
            }
          },
        ),
      ),
    );
  }
}
