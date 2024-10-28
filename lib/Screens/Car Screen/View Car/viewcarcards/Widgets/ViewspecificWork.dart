
import 'package:flutter/material.dart';
import 'package:rentel_round/Screens/Car%20Screen/View%20Car/viewcartiles.dart';

class specificWork extends StatefulWidget {
  specificWork({
    super.key,
    required this.work,
    this.date,
  });
  final String work;
  final DateTime? date;

  @override
  State<specificWork> createState() => _specificWorkState();
}

class _specificWorkState extends State<specificWork> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.work),
        Container(
          child:widget.date!=null? ViewCarTiles().viewDateForWC(widget.date!):Text("Not Done Recently"),
        ) ,

      ],
    );
  }
}
