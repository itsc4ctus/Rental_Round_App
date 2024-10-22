import 'package:flutter/material.dart';
import 'package:rentel_round/Screens/Car%20Screen/View%20Car/viewcartiles.dart';

class Otherexpensetile extends StatefulWidget {
  String expType;
  int expAmt;
  DateTime dateTime;
  Otherexpensetile(
      {required this.expType,
      required this.expAmt,
      required this.dateTime,
      super.key});

  @override
  State<Otherexpensetile> createState() => _OtherexpensetileState();
}

class _OtherexpensetileState extends State<Otherexpensetile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 25,
              width: 100,
              child: ViewCarTiles().viewDateThree(widget.dateTime),
            ),
            SizedBox(
              height: 25,
              width: 120,
              child: Text(widget.expType),
            ),
            SizedBox(
              height: 25,
              width: 70,
              child: Text(":₹${widget.expAmt}"),
            ),
          ],
        ),
      ),
    );
  }
}
