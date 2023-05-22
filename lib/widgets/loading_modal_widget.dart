import 'package:flutter/material.dart';

class LoadingModalWidget extends StatelessWidget {
  const LoadingModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(66, 0, 0, 0),
      child: Center(child: Image.asset('assets/R.gif')),
    );
  }
}
