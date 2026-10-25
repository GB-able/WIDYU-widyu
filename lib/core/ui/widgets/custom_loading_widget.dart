import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Column(
        children: [
          Spacer(flex: 2),
          CircularProgressIndicator(),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
