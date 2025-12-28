import 'package:collection/collection.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/add_review_request.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/get_all_reviews/get_all_reviews.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/manager/products_review_cubit/products_review_cubit.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/views/widgets/edit_review_bottom_sheet.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReviewSection extends StatefulWidget {
  final String slug;
  const AddReviewSection({super.key, required this.slug});

  @override
  State<AddReviewSection> createState() => _AddReviewSectionState();
}
//!
class _AddReviewSectionState extends State<AddReviewSection> {
  final _controller = TextEditingController();
  int _rating = 5;
  bool _isLoading = false;
  String? _errorMessage;

  bool _isValid() {
    if (_controller.text.trim().length < 8) {
      setState(() => _errorMessage = "التعليق لازم يكون 8 حروف على الأقل");
      return false;
    }
    setState(() => _errorMessage = null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<ProductsReviewCubit, ProductsReviewState>(
      listener: (context, state) {
        // لما ينجح الإضافة أو الحذف → نحدث القايمة
        if (state is AddProductsReviewSuccess ||
            state is DeleteProductReviewSuccess) {
          setState(() => _isLoading = false);
          _controller.clear();
          _rating = 5;
        }
        if (state is ProductsReviewFailure) {
          setState(() => _isLoading = false);
          CustomSnakeBar(context, state.errMessage);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10)],
        ),
        child: FutureBuilder<String?>(
          future: LoginRepoImp.getUserId(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 60,
                child: CustomLoadingIndicator(),
              );
            }

            final currentUserId = snapshot.data;

            return BlocBuilder<ProductsReviewCubit, ProductsReviewState>(
              builder: (context, state) {
                final reviews = state is ProductsReviewSuccess
                    ? state.getAllReviews!
                    : <GetAllReviews>[];
                final userReview = reviews.firstWhereOrNull(
                  (r) => r.user?.id.toString() == currentUserId,
                );

                // لو عنده تقييم → يظهر زر تعديل + حذف
                if (userReview != null) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "لقد قيّمت المنتج مسبقًا",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              final cubit = context.read<ProductsReviewCubit>();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => BlocProvider.value(
                                  value: cubit,
                                  child: EditReviewBottomSheet(
                                    review: userReview,
                                    slug: widget.slug,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("تعديل"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.tertiaryFixed,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              context
                                  .read<ProductsReviewCubit>()
                                  .deleteProductItemReview(userReview.id!);
                            },
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text("حذف"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                // لو مفيش تقييم → يظهر الـ TextField
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (i) => GestureDetector(
                          onTap: () => setState(() => _rating = i + 1),
                          child: Icon(
                            i < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "اكتب تقييمك (8 حروف على الأقل)...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        errorText: _errorMessage,
                        counterText: "${_controller.text.length}/8",
                      ),
                      maxLines: 3,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (!_isValid()) return;
                              setState(() => _isLoading = true);
                              context
                                  .read<ProductsReviewCubit>()
                                  .addProductItemReview(
                                    widget.slug,
                                    AddReviewRequest(
                                      rating: _rating,
                                      comment: _controller.text.trim(),
                                    ),
                                  );
                            },
                      child: _isLoading
                          ? const CustomLoadingIndicator()
                          : const Text("إرسال التقييم"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/*
class AddReviewSection extends StatefulWidget {
  final String slug;
  const AddReviewSection({super.key, required this.slug});

  @override
  State<AddReviewSection> createState() => _AddReviewSectionState();
}

class _AddReviewSectionState extends State<AddReviewSection> {
  final _controller = TextEditingController();
  int _rating = 5;
  bool _isLoading = false;

  Future<bool> _hasReviewed() async {
    final userId = await LoginRepoImp.getUserId();
    final state = context.read<ProductsReviewCubit>().state;
    if (state is ProductsReviewSuccess) {
      return state.getAllReviews!.any((r) => r.user?.id.toString() == userId);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsReviewCubit, ProductsReviewState>(
      listener: (context, state) {
        if (state is addProductsReviewSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Added Succesfully")));
          _controller.clear();
        }
        if (state is DeleteProductReviewSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("تم الحذف")));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10)],
        ),
        child: FutureBuilder<bool>(
          future: _hasReviewed(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return const Text(
                "لقد قيّمت المنتج مسبقًا",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (i) => GestureDetector(
                      onTap: () => setState(() => _rating = i + 1),
                      child: Icon(
                        i < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "اكتب تقييمك هنا...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_controller.text.trim().isEmpty) return;
                          setState(() => _isLoading = true);
                          context
                              .read<ProductsReviewCubit>()
                              .addProductItemReview(
                                widget.slug,
                                AddReviewRequest(
                                  rating: _rating,
                                  comment: _controller.text.trim(),
                                ),
                              );
                        },
                  icon: _isLoading
                      ? const CircularProgressIndicator()
                      : Icon(Icons.send, color: kPrimaryColor),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
*/

/*
class AddProductReviewSection extends StatefulWidget {
  final int productId;
  final String slug;
  final List<GetAllReviews> allReviews;
  const AddProductReviewSection({
    super.key,
    required this.productId,
    required this.slug,
    required this.allReviews,
  });

  @override
  State<AddProductReviewSection> createState() =>
      _AddProductReviewSectionState();
}

class _AddProductReviewSectionState extends State<AddProductReviewSection> {
  final TextEditingController _controller = TextEditingController();
  int _rating = 5;
  bool _isLoading = false;
  bool get _hasUserReviewed {
    final userId = LoginRepoImp.getUserId(); // افترض عندك دالة جاهزة
    return widget.allReviews.any(
      (review) => review.user?.id.toString() == userId,
    );
  }

  @override
  void initState() {
    super.initState();
    // لو عنده تقييم قبل كده، نملي الحقول منه
    if (_hasUserReviewed) {
      final userReview = widget.allReviews.firstWhere(
        (r) => r.user?.id.toString() == LoginRepoImp.getUserId(),
      );
      _controller.text = userReview.comment ?? "";
      _rating = userReview.rating ?? 5;
    }
  }

  Future<void> _submitReview() async {
    if (_hasUserReviewed || _controller.text.trim().isEmpty || _isLoading)
      return;

    setState(() => _isLoading = true);

    final request = AddReviewRequest(
      rating: _rating,
      comment: _controller.text.trim(),
    );

    final result = await context.read<ProductsCubit>().addProductItemReview(
      widget.slug,
      request,
    );

    // result.fold(
    //   (failure) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text("فشل: ${failure.errMessage}"),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   },
    //   (success) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text("تم إضافة تقييمك بنجاح!"),
    //         backgroundColor: Colors.green,
    //       ),
    //     );
    //     // ريفرش الصفحة أو أعد تحميل التقييمات
    //     context.read<ProductsCubit>().getAllProductReviews(widget.slug);
    //   },
    // );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
*/
