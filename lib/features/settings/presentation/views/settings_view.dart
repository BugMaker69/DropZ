import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/features/settings/presentation/views/widgets/settings_view_body.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.userRole});
  final String userRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), backgroundColor: kPrimaryColor),
      body: SettingsViewBody(userRole: userRole),
    );
  }
}
