import 'package:flutter/cupertino.dart';

class totalAmountWidget extends StatelessWidget {
  const totalAmountWidget({
    super.key,
    required this.screenHeight,
    required this.showRoomAmount,
  });

  final double screenHeight;
  final int showRoomAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.05,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("TOTAL AMOUNT:"),
          Container(
            transformAlignment: AlignmentDirectional.bottomCenter,
            child: Text("₹ ${showRoomAmount.toString()}"),
          ),
        ],
      ),
    );
  }
}
