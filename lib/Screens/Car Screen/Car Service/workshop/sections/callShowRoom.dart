import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class callSection extends StatelessWidget {
  const callSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade900),
            height: screenHeight * 0.1,
            width: screenWidth * 0.2,
            child: Icon(
              size: kIsWeb ? screenWidth * 0.040 : screenWidth * 0.1,
              Icons.call,
              color: Colors.white,
            ),
          ),
        ),
        const Text("CALL\nSHOWROOM")
      ],
    );
  }
}
