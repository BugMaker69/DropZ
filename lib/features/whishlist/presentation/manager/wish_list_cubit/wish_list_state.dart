part of 'wish_list_cubit.dart';

sealed class WishListState extends Equatable {
  const WishListState();

  @override
  List<Object> get props => [];
}

final class WishListInitial extends WishListState {}

final class WishListLoading extends WishListState {}

final class WishListFailure extends WishListState {
  final String errMessage;

  const WishListFailure(this.errMessage);
}

final class WishListSuccess extends WishListState {
  final WishListDataResponse wishListDataResponse;

  const WishListSuccess(this.wishListDataResponse);
}

final class AddItemToWishListSuccess extends WishListState {
  final AddRemoveProductToWishListResponse addRemoveProductToWishListResponse;

  const AddItemToWishListSuccess(this.addRemoveProductToWishListResponse);
}

final class DeleteItemFromWishListSuccess extends WishListState {
  final AddRemoveProductToWishListResponse addRemoveProductToWishListResponse;

  const DeleteItemFromWishListSuccess(this.addRemoveProductToWishListResponse);
}
