import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith("file://")) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

// ignore: must_be_immutable
class CustomImageView extends StatelessWidget {
  CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.splashColor,
    this.placeHolder = "",
    this.enableShimmer = true,
    this.showPlaceholder = true,
  });

  /// limagePathi is required parameter for showing image
  String? imagePath;
  double? height;
  double? width;
  Color? color;
  BoxFit? fit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? radius;
  BoxBorder? border;
  Color? splashColor;
  bool enableShimmer;
  bool showPlaceholder;

  @override
  Widget build(BuildContext context) {
    return alignment != null ? Align(alignment: alignment!, child: _buildWidget()) : _buildWidget();
  }

  Widget _buildWidget() {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: InkWell(onTap: onTap, splashColor: splashColor, child: _buildCircleImage()),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(borderRadius: radius ?? BorderRadius.zero, child: _buildImageWithBorder());
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: color != null ? ColorFilter.mode(color ?? Colors.transparent, BlendMode.srcIn) : null,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, url, error) =>
                showPlaceholder ? Image.asset(placeHolder, height: height, width: width, fit: fit ?? BoxFit.cover) : const SizedBox.shrink(),
          );

        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imagePath!,
            color: color,
            // placeholder: (context, url) => SizedBox(
            //   height: 30,
            //   width: 30,
            //   child: LinearProgressIndicator(
            //     color: AppTheme.inactiveColor.withValues(alpha: 0.2),
            //     backgroundColor: AppTheme.inactiveColor.withValues(alpha: 0.5),
            //   ),
            // ),
            errorWidget: (context, url, error) => showPlaceholder
                ? Image.asset(placeHolder, height: height, width: width, fit: fit ?? BoxFit.cover)
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: LinearProgressIndicator(
                      // color: AppTheme.inactiveColor.withValues(alpha: 0.2),
                      // backgroundColor: AppTheme.inactiveColor.withValues(alpha: 0.5),
                    ),
                  ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, url, error) =>
                showPlaceholder ? Image.asset(placeHolder, height: height, width: width, fit: fit ?? BoxFit.cover) : const SizedBox.shrink(),
          );
      }
    }
    return Image.asset(placeHolder, height: height, width: width, fit: fit ?? BoxFit.cover, color: color);
  }
}
