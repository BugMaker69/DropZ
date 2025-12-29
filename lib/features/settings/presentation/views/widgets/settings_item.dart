import 'package:drop_z_ecommerce_app/features/settings/data/model/settings_item_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key, required this.itemData});
  final SettingsItemData itemData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        GoRouter.of(context).push(itemData.pathRoute);
      },
      leading: Icon(itemData.icon),
      title: Text(itemData.title, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
