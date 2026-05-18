import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType { svg, png, network, file }

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    super.key,
    this.imageUrl,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.errorWidget,
    this.semanticLabel,
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;

  final Widget? errorWidget;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget child = _buildImage();

    if (radius != null) {
      child = ClipRRect(
        borderRadius: radius!,
        child: child,
      );
    }

    if (border != null) {
      child = Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: child,
      );
    }

    if (margin != null) {
      child = Padding(
        padding: margin!,
        child: child,
      );
    }

    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }

    return InkWell(
      onTap: onTap,
      child: child,
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _errorView();
    }

    try {
      switch (imageUrl!.imageType) {
        case ImageType.svg:
          return SvgPicture.network(
            imageUrl!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (_) => _loadingView(),
          );

        case ImageType.file:
          return Image.file(
            File(imageUrl!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (_, __, ___) => _errorView(),
          );

        case ImageType.network:
          return CachedNetworkImage(
            imageUrl: imageUrl!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            placeholder: (_, __) => _loadingView(),
            errorWidget: (_, __, ___) => _errorView(),
          );

        case ImageType.png:
          return Image.asset(
            imageUrl!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (_, __, ___) => _errorView(),
          );
      }
    } catch (e) {
      return _errorView();
    }
  }

  Widget _loadingView() {
    return SizedBox(
      height: height ?? 30,
      width: width ?? 30,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _errorView() {
    return errorWidget ??
        Container(
          height: height,
          width: width,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
  }
}