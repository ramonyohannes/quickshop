import 'package:flutter/material.dart';

class EmptyDisplay extends StatelessWidget {
  final String message;
  const EmptyDisplay(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('lib/assets/images/waiting.png'),
          ),
        ],
      ),
    );
  }
}
