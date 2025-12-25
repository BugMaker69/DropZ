import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.image,
    this.fit = BoxFit.scaleDown,
    this.icon = Icons.broken_image,
    this.height,
    this.width,
  });

  final String? image;
  final BoxFit? fit;
  final IconData? icon;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: image ?? "",
      fit: fit,
      errorWidget: (context, error, stackTrace) =>
          Icon(icon, size: 48, color: Colors.grey),
      placeholder: (context, url) =>
          const Center(child: CustomLoadingIndicator()),
    );
  }
}
