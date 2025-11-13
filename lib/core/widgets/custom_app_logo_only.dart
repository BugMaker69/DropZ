import 'package:drop_z_ecommerce_app/core/utils/assets.dart';
import 'package:flutter/material.dart';

class CustomAppBarLogoOnly extends StatelessWidget {
  const CustomAppBarLogoOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          AssetsData.logo,
          height: 170,
          width: 170,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
