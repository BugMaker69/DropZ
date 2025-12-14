import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_product_to_wish_list_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_remove_product_to_wish_list_response.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/wish_list_data_response/wish_list_data_response.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/repos/whishlist_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit(this.whishlistRepo) : super(WishListInitial());

  final WhishlistRepo whishlistRepo;

  WishListDataResponse? _wishlistData;

  Future<void> getAllWishList() async {
    if (_wishlistData != null) {
      emit(WishListSuccess(_wishlistData!));
      return;
    }

    await CubitHandler.run<WishListDataResponse>(
      cubit: this,
      loadingState: () => emit(WishListLoading()),
      call: () => whishlistRepo.getAllWishList(),
      onSuccess: (data) {
        _wishlistData = data;
        emit(WishListSuccess(data));
      },
      failureState: (msg) => emit(WishListFailure(msg)),
    );
  }

  Future<void> refreshWishlist(BuildContext context) async {
    _wishlistData = null;
    await whishlistRepo.clearCacheAndReload();
    await getAllWishList();
  }

  Future<void> addWishListItem(AddProductToWishListRequest request) async =>
      await CubitHandler.run<AddRemoveProductToWishListResponse>(
        cubit: this,
        loadingState: () => emit(WishListLoading()),
        call: () => whishlistRepo.addWishListItem(request),
        onSuccess: (response) async {
          emit(AddItemToWishListSuccess(response));
          _wishlistData = null;
          await whishlistRepo.clearCacheAndReload();
          await getAllWishList();
        },
        failureState: (msg) => emit(WishListFailure(msg)),
      );

  Future<void> removeWishListItem(int id) async =>
      await CubitHandler.run<AddRemoveProductToWishListResponse>(
        cubit: this,
        loadingState: () => emit(WishListLoading()),
        call: () => whishlistRepo.removeWishListItem(id),
        onSuccess: (response) async {
          emit(DeleteItemFromWishListSuccess(response));
          _wishlistData = null;
          await whishlistRepo.clearCacheAndReload();
          await getAllWishList();
        },
        failureState: (msg) => emit(WishListFailure(msg)),
      );
}
