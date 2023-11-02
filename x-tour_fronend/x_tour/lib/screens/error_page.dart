import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: AssetImage("assets/cuate.png")),
            Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text("OOPS...",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child:
                  Text("Something went wrong!", style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
