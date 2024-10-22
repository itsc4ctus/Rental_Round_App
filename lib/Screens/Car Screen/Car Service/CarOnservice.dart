import 'package:flutter/material.dart';
import 'package:rentel_round/Models/workshop_model.dart';
import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/workshop/workshopScreen.dart';
import 'package:rentel_round/Screens/Car%20Screen/View%20Car/viewcar_screen.dart';
import 'package:rentel_round/Services/expence_services.dart';
import 'package:rentel_round/Services/workshop_services.dart';
import 'dart:io';

import '../../../Models/car_model.dart';
import '../../../Services/car_services.dart';

class CarOnService extends StatefulWidget {
  String image;
  String carName;
  String vehicleNo;
  Cars car;
  CarOnService(
      {required this.image,
      required this.carName,
      required this.vehicleNo,
      required this.car,
      super.key});

  @override
  State<CarOnService> createState() => _CarOnServiceState();
}

class _CarOnServiceState extends State<CarOnService> {
  List<WorKShopModel> intakeList = [];
  late WorKShopModel inTake;
  Future<void> _takeWorkshop() async {
    List<WorKShopModel> list = await WorkshopServices().getTakeToWork();

    setState(() {
      for (var value in list) {
        if (value.car.vehicleNo == widget.car.vehicleNo) {
          inTake = value;
        }
      }
    });
  }

  TextEditingController serviceChargeController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    _takeWorkshop();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewcarScreen(car: widget.car),
                        ));
                  },
                  child: Image(
                    image: FileImage(File(widget.image)),
                  )),
            ),
            Column(
              children: [
                Text(widget.carName),
                Text(widget.vehicleNo),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  _takeWorkshop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkShopScreen(car: widget.car, inTake: inTake),
                      ));
                },
                child: const Text("WORKSHOP"))
          ],
        ),
      ),
    );
  }

  showError() {
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Enter Service Charge")));
  }
}
