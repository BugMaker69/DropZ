import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/get_all_reviews/get_all_reviews.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/views/widgets/edit_review_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ProductReviewItem extends StatelessWidget {
  final GetAllReviews getReview;
  final String slug;
  final VoidCallback? onEdit;

  const ProductReviewItem({
    super.key,
    required this.getReview,
    required this.slug,
    this.onEdit,
  });

  Future<bool> _isCurrentUserReview() async {
    final currentUserId = await LoginRepoImp.getUserId();
    return getReview.user?.id.toString() == currentUserId;
  }

  void _edit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditReviewBottomSheet(review: getReview, slug: slug),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade200,
          child: (getReview.user?.profileImage?.isNotEmpty ?? false)
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: getReview.user!.profileImage!,
                    fit: BoxFit.cover,
                    width: 56,
                    height: 56,
                    errorWidget: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      );
                    },
                    placeholder: (context, url) => CustomLoadingIndicator(),
                  ),
                )
              : const Icon(Icons.person, size: 30, color: Colors.grey),
        ),
        trailing: Text(
          _formatDate(getReview.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        title: Text(
          getReview.user!.name!,
          style: Styles.textStyle16Medium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(getReview.comment!, style: Styles.textStyle16Medium),
            const SizedBox(height: 8),

            Row(
              children: [
                // نجوم التقييم
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < (getReview.rating ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${getReview.rating ?? 0}/5",
                  style: Styles.textStyle14Regular.copyWith(color: Colors.grey),
                ),
              ],
            ),
            /* FutureBuilder<bool>(
              future: _isCurrentUserReview(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 20,
                        ),
                        onPressed: onEdit,
                        // () {
                        //   _edit(context);
                        // },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          context
                              .read<ProductsReviewCubit>()
                              .deleteProductItemReview(getReview.id!);
                          GoRouter.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
         */
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown";
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "Just now";
  }
}
