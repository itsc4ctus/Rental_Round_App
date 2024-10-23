import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rentel_round/Models/workshop_model.dart';
import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/workshop/ViewCompletedWork.dart';
import 'package:rentel_round/Screens/Car%20Screen/View%20Car/viewcartiles.dart';

class WorkShoptile extends StatefulWidget {
  WorKShopModel workshop;
  WorkShoptile({required this.workshop, super.key});

  @override
  State<WorkShoptile> createState() => _WorkShoptileState();
}

class _WorkShoptileState extends State<WorkShoptile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewCompletedWork(
                note: widget.workshop.serviceNote,
                billImage: widget.workshop.reciptPhoto.toString(),
                serviceAmount: widget.workshop.serviceAmount,
                garageName: widget.workshop.workShopName.toString(),
                phoneNumber: widget.workshop.workShopNumber,
              ),
            ));
      },
      child: Card(
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          width: 200,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image(
                    image: FileImage(File(widget.workshop.car.carImage)),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("SERVICE DATE"),
                      ViewCarTiles().viewDateTwo(widget.workshop.dateTime),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: Row(
                    children: [
                      Text("₹ ${widget.workshop.serviceAmount}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
