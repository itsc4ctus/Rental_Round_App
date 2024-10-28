import 'package:flutter/material.dart';
import 'package:rentel_round/Models/car_model.dart';
import 'ViewspecificWork.dart';
class ConditionPage extends StatefulWidget {
  ConditionPage({required this.car,super.key});
  final Cars car;
  @override
  State<ConditionPage> createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CAR CONDITION"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(

                  children: [
                    specificWork(work: "BREAK TESTED",date: widget.car.brakeChanged,),
                    SizedBox(
                      height: 5,
                    ),
                    specificWork(work: "TYRE TESTED",date: widget.car.tyreChanged,),
                    SizedBox(
                      height: 5,
                    ),
                    specificWork(work: "ENGINE TESTED",date: widget.car.engineWork,),
                    SizedBox(
                      height: 5,
                    ),
                    specificWork(work: "FILTER TESTED",date: widget.car.fliterChanged,),
                    SizedBox(
                      height: 5,
                    ),
                    specificWork(work: "OIL TESTED",date: widget.car.oilChanged,),
                    SizedBox(
                      height: 5,
                    ),
                    specificWork(work: "TRANSMISSION TESTED",date: widget.car.transmissionService,),
                    SizedBox(
                      height: 5,
                    ),
                    specificWork(work: "BATTERY TESTED",date: widget.car.batteryWork,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
