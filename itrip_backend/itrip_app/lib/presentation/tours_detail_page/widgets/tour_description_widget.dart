import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TourDescriptionWidget extends StatefulWidget {
  final String description;
  final List<String> included;
  final List<String> notIncluded;

  const TourDescriptionWidget({
    super.key,
    required this.description,
    required this.included,
    required this.notIncluded,
  });

  @override
  State<TourDescriptionWidget> createState() => _TourDescriptionWidgetState();
}

class _TourDescriptionWidgetState extends State<TourDescriptionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxLines = _isExpanded ? null : 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Аяллын тухай',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 1.5.h),

        // Description text
        Text(
          widget.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          maxLines: maxLines,
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
        ),

        // Read more button
        TextButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            _isExpanded ? 'Багасгах' : 'Дэлгэрэнгүй',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // What's included section
        Text(
          'Юу багтсан',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 1.h),

        ...widget.included.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 0.5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.green,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    item,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // What's not included section
        Text(
          'Юу багтаагүй',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 1.h),

        ...widget.notIncluded.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 0.5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'cancel',
                  color: Colors.red,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    item,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
