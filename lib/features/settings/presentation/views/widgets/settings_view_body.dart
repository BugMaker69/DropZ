import 'package:drop_z_ecommerce_app/core/providers/theme_provider.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/manager/user_profile_cubit/user_profile_cubit.dart';
import 'package:drop_z_ecommerce_app/features/settings/data/model/settings_item_data.dart';
import 'package:drop_z_ecommerce_app/features/settings/presentation/views/widgets/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key, required this.userRole});

  final String userRole;

  @override
  Widget build(BuildContext context) {
    final List<SettingsItemData> customerItemsData = [
      SettingsItemData(
        title: "Profile",
        icon: Icons.person_outline_outlined,
        pathRoute: AppRouter.kCustomerProfileView,
      ),
      SettingsItemData(
        title: "Change Password",
        icon: Icons.lock_outlined,
        pathRoute: AppRouter.kCustomerChangePassword,
      ),
      SettingsItemData(
        title: "Address",
        icon: Icons.location_on_outlined,
        pathRoute: AppRouter.kCustomerAddress,
      ),
      //! Add Support
      SettingsItemData(
        title: "Support",
        icon: Icons.contact_support_outlined,
        pathRoute: AppRouter.kCustomerSupport,
      ),
      //! Add Orders
    ];

    final List<SettingsItemData> sellerItemsData = [
      SettingsItemData(
        title: "Profile",
        icon: Icons.person_outline_outlined,
        pathRoute: AppRouter.kSellerProfileView,
      ),
      SettingsItemData(
        title: "Change Password",
        icon: Icons.lock_outlined,
        pathRoute: AppRouter.kSellerChangePassword,
      ),
    ];

    final itemsData = userRole == "seller"
        ? sellerItemsData
        : customerItemsData;
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          context.go(AppRouter.kloginView);
        }
      },
      builder: (context, state) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        // دمج كل العناصر بما فيها Toggle و LogOut داخل ListView
        final allItems = [
          ...itemsData.map((item) => SettingsItem(itemData: item)),
          ListTile(
            leading: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
            ),
          ),
          ListTile(
            onTap: () {
              context.read<UserProfileCubit>().logOut();
            },
            iconColor: Colors.red,
            leading: const Icon(Icons.logout_outlined),
            title: Text(
              "LogOut",
              style: Styles.textStyle16Medium.copyWith(color: Colors.red),
            ),
          ),
        ];

        return ListView.separated(
          itemCount: allItems.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) => allItems[index],
        );
      },
    );

    /*    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          return context.go(AppRouter.kloginView);
        }
      },
      builder: (context, state) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) =>
                    SettingsItem(itemData: itemsData[index]),
                itemCount: itemsData.length,
                separatorBuilder: (context, index) => Divider(),
              ),
            ),

            ListTile(
              leading: Icon(
                themeProvider.isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (val) {
                  themeProvider.toggleTheme(val);
                },
              ),
            ),
            ListTile(
              onTap: () {
                context.read<UserProfileCubit>().logOut();
              },
              iconColor: Colors.red,
              leading: Icon(Icons.logout_outlined),
              title: Text(
                "LogOut",
                style: Styles.textStyle16Medium.copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  */
  }
}
