import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TourReviewsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;
  final int totalReviews;

  const TourReviewsWidget({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Сэтгэгдэл',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all reviews screen
              },
              child: Text('Бүгдийг үзэх ($totalReviews)'),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Rating summary
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Large rating number
              Text(
                averageRating.toStringAsFixed(1),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(width: 3.w),

              // Stars and count
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName: index < averageRating.floor()
                            ? 'star'
                            : 'star_border',
                        color: Colors.amber,
                        size: 18,
                      );
                    }),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '$totalReviews сэтгэгдэл дээр үндэслэсэн',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Recent reviews
        ...reviews
            .take(3)
            .map(
              (review) => Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info and rating
                    Row(
                      children: [
                        // User avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CustomImageWidget(
                            imageUrl: review["userAvatar"] as String,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            semanticLabel: review["semanticLabel"] as String,
                          ),
                        ),

                        SizedBox(width: 3.w),

                        // User name and date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review["userName"] as String,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _formatDate(review["date"] as String),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Rating stars
                        Row(
                          children: List.generate(5, (index) {
                            final rating = review["rating"] as double;
                            return CustomIconWidget(
                              iconName: index < rating.floor()
                                  ? 'star'
                                  : 'star_border',
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.5.h),

                    // Review comment
                    Text(
                      review["comment"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Өнөөдөр';
    } else if (difference.inDays == 1) {
      return 'Өчигдөр';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} өдрийн өмнө';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} 7 хоногийн өмнө';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
