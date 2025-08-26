import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/assets.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/features/home/presentation/manager/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/views/profile_view.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (context, bottomIndex) {
          return DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                title: Row(
                  children: [
                    Image.asset(
                      AssetsData.logo,
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.dark_mode_outlined),
                      iconSize: 32,
                      color: kSecondaryColor,
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
                                onTap: () {
                                  GoRouter.of(
                                    context,
                                  ).push(AppRouter.kSearchView);
                                },
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: kSecondaryColor,
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                  alignLabelWithHint: false,
                                  labelText: "Search",
                                  floatingLabelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  labelStyle: Styles.textStyle18Regular,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      // width: 50,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            // 📑 Tabs
                            TabBar(
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              indicatorColor: kSecondaryColor,
                              labelColor: kSecondaryColor,
                              unselectedLabelColor: Colors.white,
                              tabs: [
                                Text(
                                  "explore",
                                  style: Styles.textStyle20Medium,
                                ),
                                Text(
                                  "Men’s fashion",
                                  style: Styles.textStyle20Medium,
                                ),
                                Text(
                                  "Women’s fashion",
                                  style: Styles.textStyle20Medium,
                                ),
                                Text(
                                  "Electronics",
                                  style: Styles.textStyle20Medium,
                                ),
                                Text(
                                  "Home & Lifestyle",
                                  style: Styles.textStyle20Medium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
              backgroundColor: kPrimaryColor,
              body: IndexedStack(
                index: bottomIndex,
                children: [
                  TabBarView(
                    // اسحب يمين/شمال للتنقل
                    children: [
                      Center(
                        child: Text(
                          'Home Page',
                          style: Styles.textStyle20Medium,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Search Page',
                          style: Styles.textStyle20Medium,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Home Page',
                          style: Styles.textStyle20Medium,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Search Page',
                          style: Styles.textStyle20Medium,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Profile Page',
                          style: Styles.textStyle20Medium,
                        ),
                      ),
                    ],
                  ),
                  // 🔍 Search
                  SearchView(),
                  // 👤 Profile
                  ProfileView(),
                ],
              ),
              bottomNavigationBar: NavigationBar(
                indicatorColor: kSecondaryColor,
                shadowColor: kSecondaryColor,
                surfaceTintColor: kSecondaryColor,
                backgroundColor: Colors.grey.shade800,
                selectedIndex: bottomIndex,
                onDestinationSelected: (index) =>
                    context.read<BottomNavCubit>().changeTab(index),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                  NavigationDestination(
                    icon: Icon(Icons.search),
                    label: "Search",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
