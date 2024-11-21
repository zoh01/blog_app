import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZLoader extends StatelessWidget {
  const ZLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    );
  }
}
