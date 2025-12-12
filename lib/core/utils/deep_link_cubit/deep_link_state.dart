part of 'deep_link_cubit.dart';

abstract class DeepLinkState {}

class DeepLinkInitial extends DeepLinkState {}

class DeepLinkOpenedProduct extends DeepLinkState {
  final String productId;

  DeepLinkOpenedProduct(this.productId);
}
