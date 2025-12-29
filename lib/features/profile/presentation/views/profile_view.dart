import 'package:drop_z_ecommerce_app/features/profile/presentation/views/widgets/profile_view_body.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.editProfile}"),
      ),
      body: ProfileViewBody(),
    );
  }
}
