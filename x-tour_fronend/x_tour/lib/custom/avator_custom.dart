import 'package:flutter/material.dart';

class profile_avatar extends StatelessWidget {
  profile_avatar({
    super.key,
    this.radius = 50,
    this.imageUrl = "",
    this.text = '',
    this.isAsset = false,
  });

  final bool isAsset;
  final double radius;
  final String imageUrl;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      width: radius,
      height: radius,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Theme.of(context).primaryColor),
      child: CircleAvatar(
          radius: radius,
          backgroundImage: isAsset
              ? Image.asset('assets/person_kelvin.jpg').image
              : NetworkImage("http://10.0.2.2:3000/${imageUrl}")),
    );
  }
}
