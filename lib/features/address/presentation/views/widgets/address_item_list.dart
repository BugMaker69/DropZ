import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/address_item.dart';
import 'package:flutter/material.dart';

class AddressItemList extends StatelessWidget {
  final List<AddressResponse> getAlladdresses;
  const AddressItemList({super.key, required this.getAlladdresses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) =>
          AddressItem(addressResponse: getAlladdresses[index]),
      itemCount: getAlladdresses.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
    );
  }
}
