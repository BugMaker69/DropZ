import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/assets.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(AssetsData.logo, height: 100, width: 100),
            // SizedBox(width: 16),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.dark_mode_outlined),
              iconSize: 48,
              color: kSecondaryColor,
            ),
          ],
        ),
        TextFormField(
          onTap: () {
            GoRouter.of(context).push(AppRouter.kProfileView);
          },
          cursorColor: Colors.white,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            contentPadding: const EdgeInsets.all(16),
            alignLabelWithHint: false,
            labelText: "Search",
            floatingLabelStyle: const TextStyle(color: Colors.white),
            labelStyle: Styles.textStyle18Regular,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
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
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 30,
            children: [
              Text("Electronics", style: Styles.textStyle20Medium),
              Text("Men’s fashion", style: Styles.textStyle20Medium),
              Text("Women’s fashion", style: Styles.textStyle20Medium),
              Text("Home & Lifestyle", style: Styles.textStyle20Medium),
            ],
          ),
        ),
        CustomButton(
          text: "Go To Profile",
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kProfileView);
          },
        ),
      ],
    );
  }
}
