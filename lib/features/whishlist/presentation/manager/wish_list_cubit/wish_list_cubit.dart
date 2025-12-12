import 'package:bloc/bloc.dart';
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
    if (_wishlistData == null) {
      emit(WishListLoading());
      var result = await whishlistRepo.getAllWishList();
      result.fold(
        (failure) {
          emit(WishListFailure(failure.toString()));
        },
        (wishlistDataSuccess) {
          _wishlistData = wishlistDataSuccess;
          emit(WishListSuccess(wishlistDataSuccess));
        },
      );

      return;
    }
    emit(WishListSuccess(_wishlistData!));
  }

  Future<void> refreshWishlist(BuildContext context) async {
    await whishlistRepo.clearCacheAndReload(); // مسح الـ Cache
    await getAllWishList(); // تحميل البيانات من جديد
    // context.read<ProductsCubit>().refreshAllData();
  }

  Future<void> addWishListItem(
    AddProductToWishListRequest addProductToWishListRequest,
  ) async {
    emit(WishListLoading());
    var result = await whishlistRepo.addWishListItem(
      addProductToWishListRequest,
    );

    result.fold(
      (failure) {
        emit(WishListFailure(failure.toString()));
      },
      (addProductToWishListResponse) async {
        emit(AddItemToWishListSuccess(addProductToWishListResponse));
        _wishlistData = null;
        await whishlistRepo.clearCacheAndReload();
        await getAllWishList();
        // await refreshWishlist(context);
      },
    );
  }

  Future<void> removeWishListItem(int id) async {
    emit(WishListLoading());

    var result = await whishlistRepo.removeWishListItem(id);

    result.fold(
      (failure) {
        emit(WishListFailure(failure.toString()));
      },
      (removeProductToWishListResponse) async {
        emit(DeleteItemFromWishListSuccess(removeProductToWishListResponse));
        _wishlistData = null;
        await whishlistRepo.clearCacheAndReload();
        await getAllWishList();

        // await refreshWishlist(context);
      },
    );
  }
}
