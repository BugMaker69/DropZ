import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/add_review_request.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/get_all_reviews/get_all_reviews.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/manager/products_review_cubit/products_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditReviewBottomSheet extends StatefulWidget {
  final GetAllReviews review;
  final String slug;
  const EditReviewBottomSheet({
    super.key,
    required this.review,
    required this.slug,
  });

  @override
  State<EditReviewBottomSheet> createState() => _EditReviewBottomSheetState();
}

class _EditReviewBottomSheetState extends State<EditReviewBottomSheet> {
  late TextEditingController _controller;
  late int _rating;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.review.comment);
    _rating = widget.review.rating ?? 5;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValid() {
    if (_controller.text.trim().length < 8) {
      setState(() {
        _errorMessage = "التعليق لازم يكون 8 حروف على الأقل";
      });
      return false;
    }
    setState(() => _errorMessage = null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsReviewCubit, ProductsReviewState>(
      listener: (context, state) {
        // لما ينجح التعديل → نقفل الـ BottomSheet ونظهر رسالة
        if (state is ProductsReviewSuccess) {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم تعديل التقييم بنجاح!"),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
        if (state is ProductsReviewFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "تعديل التقييم",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // النجوم
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
              const SizedBox(height: 16),

              // التعليق
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "عدل تقييمك (8 حروف على الأقل)...",
                  errorText: _errorMessage,
                  counterText: "${_controller.text.length}/8",
                ),
                maxLines: 3,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (!_isValid()) return;

                          setState(() => _isLoading = true);

                          context
                              .read<ProductsReviewCubit>()
                              .updateProductItemReview(
                                widget.review.id!,
                                AddReviewRequest(
                                  rating: _rating,
                                  comment: _controller.text.trim(),
                                ),
                              );
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "حفظ التعديل",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}




/*
class EditReviewBottomSheet extends StatefulWidget {
  final GetAllReviews review;
  final String slug;
  const EditReviewBottomSheet({
    super.key,
    required this.review,
    required this.slug,
  });

  @override
  State<EditReviewBottomSheet> createState() => _EditReviewBottomSheetState();
}

class _EditReviewBottomSheetState extends State<EditReviewBottomSheet> {
  late TextEditingController _controller;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.review.comment);
    _rating = widget.review.rating ?? 5;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "تعديل التقييم",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "عدل تقييمك...",
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductsReviewCubit>().updateProductItemReview(
                widget.review.id!,
                AddReviewRequest(
                  rating: _rating,
                  comment: _controller.text.trim(),
                ),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم تعديل التقييم بنجاح")),
              );
            },
            child: const Text("حفظ التعديل"),
          ),
        ],
      ),
    );
  }
}
*/