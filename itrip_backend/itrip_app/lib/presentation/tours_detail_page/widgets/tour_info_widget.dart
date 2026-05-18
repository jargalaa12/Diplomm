import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TourInfoWidget extends StatelessWidget {
  final String groupSize;
  final String difficulty;
  final String bestSeason;

  const TourInfoWidget({
    super.key,
    required this.groupSize,
    required this.difficulty,
    required this.bestSeason,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: [
        _buildInfoChip(context, icon: 'group', label: groupSize, theme: theme),
        _buildInfoChip(
          context,
          icon: 'trending_up',
          label: difficulty,
          theme: theme,
        ),
        _buildInfoChip(
          context,
          icon: 'wb_sunny',
          label: bestSeason,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required String icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.primary,
            size: 18,
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
