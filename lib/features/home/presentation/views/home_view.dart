import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/providers/localization_provider.dart';
import 'package:drop_z_ecommerce_app/core/providers/theme_provider.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/assets.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/home/presentation/manager/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/category_procduct.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRtl =
        Provider.of<LocalizationProvider>(context).locale.languageCode == 'ar';
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit()),
        // BlocProvider(
        //   create: (context) => ProductsCubit(getIt.get<ProductsRepoImp>())
        //     ..getAllCategories()
        //     ..getAllProducts(),
        // ),
        // BlocProvider(
        //   create: (context) =>
        //       CartCubit(getIt.get<CartRepoImp>())..getCartItems(),
        // ),
      ],
      child: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: BlocBuilder<BottomNavCubit, int>(
          builder: (context, bottomIndex) {
            return BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const CustomLoadingIndicator();
                } else if (state is ProductsFailure) {
                  return CustomErrorWidget(
                    errMessage: 'Error: ${state.errMessage}',
                  );
                } else if (state is ProductsDataState &&
                    state.categories != null &&
                    state.products != null) {
                  final categories = state.categories!;
                  final products = state.products!;

                  return DefaultTabController(
                    length: categories.length + 1,
                    child: Scaffold(
                      // backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      resizeToAvoidBottomInset: true,
                      appBar: AppBar(
                        // backgroundColor: kPrimaryColor,
                        title: Row(
                          mainAxisAlignment: isRtl
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              AssetsData.logo,
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                final themeProvider =
                                    Provider.of<ThemeProvider>(
                                      context,
                                      listen: false,
                                    );
                                themeProvider.toggleTheme(
                                  !themeProvider.isDarkMode,
                                );
                              },
                              icon: Icon(
                                Provider.of<ThemeProvider>(context).isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode_outlined,
                              ),
                              iconSize: 32,
                              color: kSecondaryColor,
                            ),
                            IconButton(
                              onPressed: () {
                                final localizationProvider =
                                    Provider.of<LocalizationProvider>(
                                      context,
                                      listen: false,
                                    );
                                final newLocale =
                                    localizationProvider.locale.languageCode ==
                                        'en'
                                    ? const Locale('ar')
                                    : const Locale('en');
                                localizationProvider.setLocale(newLocale);
                              },
                              icon: Text(
                                Provider.of<LocalizationProvider>(
                                          context,
                                        ).locale.languageCode ==
                                        'en'
                                    ? 'EN'
                                    : 'AR',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: kSecondaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              iconSize: 32,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        ),
                        bottom: bottomIndex == 0
                            ? PreferredSize(
                                preferredSize: const Size.fromHeight(
                                  110,
                                ), // ارتفاع السيرش + التابز
                                child: Column(
                                  children: [
                                    // 🔍 Search Box
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: TextFormField(
                                        canRequestFocus: false,
                                        textInputAction: TextInputAction.none,
                                        readOnly: true,
                                        onTap: () {
                                          GoRouter.of(
                                            context,
                                          ).push(AppRouter.kSearchView);
                                        },
                                        cursorColor: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                        decoration: InputDecoration(
                                          suffixIcon: isRtl
                                              ? null
                                              : Icon(
                                                  Icons.search,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                                ),
                                          prefixIcon: isRtl
                                              ? Icon(
                                                  Icons.search,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                                )
                                              : null,
                                          contentPadding: const EdgeInsets.all(
                                            16,
                                          ),
                                          alignLabelWithHint: false,
                                          labelText: localizations.searchHere,
                                          floatingLabelStyle: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                          ),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              // width: 50,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // 📑 Tabs
                                    TabBar(
                                      tabAlignment: isRtl
                                          ? TabAlignment.startOffset
                                          : TabAlignment
                                                .start, // tabAlignment: TabAlignment.start,
                                      isScrollable: true,
                                      indicatorColor: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      labelColor: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      unselectedLabelColor: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      tabs: [
                                        Text(
                                          "explore",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        ...categories.map(
                                          (category) => Text(
                                            "${category.name}",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                      body: TabBarView(
                        physics:
                            const NeverScrollableScrollPhysics(), // منع السحب للتأكد من النافيجيشن
                        // اسحب يمين/شمال للتنقل
                        children: [
                          CategoryProductsView(
                            category: 0,
                            products: products,
                            roleId: 0,
                          ),
                          ...categories.map(
                            (category) => CategoryProductsView(
                              category: category.id!,
                              products: products,
                              roleId: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return CustomErrorWidget(
                    errMessage: "${localizations.waitingForData}",
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
