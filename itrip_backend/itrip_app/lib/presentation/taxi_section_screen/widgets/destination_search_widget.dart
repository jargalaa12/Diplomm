import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DestinationSearchWidget extends StatefulWidget {
  final Function(String) onDestinationSelected;
  final String? selectedDestination;

  const DestinationSearchWidget({
    super.key,
    required this.onDestinationSelected,
    this.selectedDestination,
  });

  @override
  State<DestinationSearchWidget> createState() =>
      _DestinationSearchWidgetState();
}

class _DestinationSearchWidgetState extends State<DestinationSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSuggestions = false;

  final List<Map<String, dynamic>> _recentLocations = [
    {
      "name": "Chinggis Khaan International Airport",
      "address": "Ulaanbaatar, Mongolia",
      "icon": "flight",
    },
    {
      "name": "Sukhbaatar Square",
      "address": "Central Ulaanbaatar",
      "icon": "location_city",
    },
    {
      "name": "Zaisan Memorial",
      "address": "Southern Ulaanbaatar",
      "icon": "landscape",
    },
    {
      "name": "State Department Store",
      "address": "Peace Avenue, Ulaanbaatar",
      "icon": "shopping_bag",
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedDestination != null) {
      _searchController.text = widget.selectedDestination!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outline, width: 1),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _showSuggestions = value.isNotEmpty;
              });
            },
            onTap: () {
              setState(() {
                _showSuggestions = true;
              });
            },
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Хаашаа явах вэ?',
              hintStyle: theme.inputDecorationTheme.hintStyle,
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 1.5.h,
              ),
            ),
          ),
        ),
        _showSuggestions ? SizedBox(height: 1.h) : SizedBox.shrink(),
        _showSuggestions
            ? Container(
                constraints: BoxConstraints(maxHeight: 30.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _recentLocations.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  itemBuilder: (context, index) {
                    final location = _recentLocations[index];
                    return ListTile(
                      leading: CustomIconWidget(
                        iconName: location["icon"] as String,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      title: Text(
                        location["name"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        location["address"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      onTap: () {
                        _searchController.text = location["name"] as String;
                        widget.onDestinationSelected(
                          location["name"] as String,
                        );
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    );
                  },
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
