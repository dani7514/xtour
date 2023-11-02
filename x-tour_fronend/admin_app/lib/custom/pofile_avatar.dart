import 'package:flutter/material.dart';

class profile_avatar extends StatelessWidget {
  profile_avatar(
      {super.key, this.radius = 50, this.imageUrl = "", this.isAsset = false});
  final bool isAsset;
  final double radius;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      width: radius,
      height: radius,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 79, 28, 208),
              Color.fromARGB(255, 25, 194, 224)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.5, 0.75]),
      ),
      child: CircleAvatar(
          radius: radius,
          backgroundImage: isAsset
              ? Image.asset('assets/person_kelvin.jpg').image
              : NetworkImage("http://10.0.2.2:3000/${imageUrl}")),
    );
  }
}
