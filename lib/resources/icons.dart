import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyMusicIcons {
  static Widget searchIcon({double size = 22, Key key, Color color}) {
    return _iconAssetWith('assets/icons/icon_search.svg', color, size, size,
        key: key);
  }

  static Widget _iconAssetWith(
      String assetString, Color color, double width, double height,
      {Key key}) {
    Color _color = (color == null) ? Colors.black : color;
    return SvgPicture.asset(assetString,
        color: _color,
        fit: BoxFit.contain,
        width: width,
        height: height,
        key: key);
  }
}
