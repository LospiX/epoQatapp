import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displays the official epoQatapp SVG logo at the requested size.
class AppLogo extends StatelessWidget {
  final double size;
  final Color? tint;
  final String? semanticLabel;

  const AppLogo({
    super.key,
    this.size = 40,
    this.tint,
    this.semanticLabel = 'epoQatapp',
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icon/epoQatApp_logo.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticsLabel: semanticLabel,
      colorFilter: tint == null
          ? null
          : ColorFilter.mode(tint!, BlendMode.srcIn),
    );
  }
}
