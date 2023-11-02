import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/Logo.png")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("X",
                    style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 26, 159, 112))),
                Text("-tour Ethiopia", style: TextStyle(fontSize: 25))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
