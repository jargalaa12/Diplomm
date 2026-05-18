import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AppBar variant
enum CustomAppBarVariant { standard, search, transparent }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final CustomAppBarVariant variant;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final TextEditingController? searchController;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final double? elevation;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.variant = CustomAppBarVariant.standard,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTransparent = variant == CustomAppBarVariant.transparent;

    return AppBar(
      title: _buildTitle(context),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: elevation ?? 0,
      backgroundColor: isTransparent
          ? Colors.transparent
          : theme.appBarTheme.backgroundColor,
      foregroundColor: isTransparent
          ? Colors.white
          : theme.appBarTheme.foregroundColor,
      systemOverlayStyle:
          isTransparent ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      flexibleSpace: isTransparent
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6), // FIX
                    Colors.transparent,
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    /// 🔍 SEARCH VARIANT
    if (variant == CustomAppBarVariant.search) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: searchHint ?? 'Search...',
            prefixIcon: Icon(
              Icons.search,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            suffixIcon: (searchController != null &&
                    searchController!.text.isNotEmpty)
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      searchController!.clear();
                      onSearchChanged?.call('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      );
    }

    /// 🧾 STANDARD / TRANSPARENT
    if (title != null) {
      return Text(
        title!,
        style: theme.appBarTheme.titleTextStyle,
      );
    }

    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}