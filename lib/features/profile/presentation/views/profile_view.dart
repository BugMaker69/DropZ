import 'package:drop_z_ecommerce_app/features/profile/presentation/views/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(title: Text("Edit Profile")),
      body: ProfileViewBody(),
      // backgroundColor: kPrimaryColor,
    );
  }
}
