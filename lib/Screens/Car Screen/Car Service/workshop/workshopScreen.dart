import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentel_round/Models/workshop_model.dart';
import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/workshop/ViewCompletedWork.dart';
import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/workshop/sections/callShowRoom.dart';
import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/workshop/sections/renewPollution.dart';
import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/workshop/showRoomService.dart';

import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/workshop/widget/carDetails.dart';
import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/workshop/widget/totalAmount.dart';
import 'package:rentel_round/Services/workshop_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Models/car_model.dart';
import '../../../../Services/car_services.dart';
import '../../../../Services/expence_services.dart';

class WorkShopScreen extends StatefulWidget {
  WorkShopScreen({required this.car, required this.inTake, super.key});

  final Cars car;
  final WorKShopModel inTake;

  @override
  State<WorkShopScreen> createState() => _WorkShopScreenState();
}

class _WorkShopScreenState extends State<WorkShopScreen> {
  TextEditingController serviceChargeController = TextEditingController();
  String? billPhoto;
  String note = "No Note";
  int showRoomAmount = 0;
  bool status = false;
  Future<void> _navigateBack() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowRoomService(
            phoneNumber: widget.inTake.workShopNumber,
            shopName: widget.inTake.workShopName.toString(),
          ),
        ));
    if (result != null) {
      setState(() {
        billPhoto = result['billPhoto'];
        note = result['note'];
        showRoomAmount = result['amount'];
        status = result['status'];
      });
    }
  }

  final GlobalKey<FormState> _key = GlobalKey();
  Future<void> _takeDown(
      Cars car, int serviceCharge, WorKShopModel work) async {
    await CarServices().deleteOnHoldCar(car.vehicleNo);
    await CarServices().deleteServicedCar(car.vehicleNo);
    await CarServices().addExpSerCar(car);
    car.servicedDate = DateTime.now();
    car.serviceAmount = serviceCharge;
    car.availability = true;
    await CarServices().addAvailableCar(car);
    await CarServices().getExpSerCar();
    await CarServices().getServicingCars();
    await ExpenceServices().getExpenses();
    await CarServices().updateCar(car.vehicleNo, car);
    await WorkshopServices().addCompletedForExp(work);
    await WorkshopServices().addCompleted(work);
    await WorkshopServices().updateCompletedWork(work, car.vehicleNo);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height;
    var screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Workshop"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight * 0.85,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CarDetails(widget: widget),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          _navigateBack();
                        },
                        child: Column(
                          children: [
                            Card(
                              elevation: 2,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue.shade900),
                                height: screenHeight * 0.1,
                                width: screenWidth * 0.8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      size: kIsWeb
                                          ? screenWidth * 0.040
                                          : screenWidth * 0.1,
                                      Icons.car_repair_outlined,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "ENTER SHOW ROOM",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          _getRecentService(widget.inTake);
                        },
                        child: Column(
                          children: [
                            Card(
                              elevation: 2,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue.shade900),
                                height: screenHeight * 0.1,
                                width: screenWidth * 0.2,
                                child: Icon(
                                  size: kIsWeb
                                      ? screenWidth * 0.040
                                      : screenWidth * 0.1,
                                  Icons.history_edu_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text("RECENT\nSERVICE")
                          ],
                        ),
                      ),
                      renewPollutionSection(
                          widget: widget,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                      InkWell(
                        onTap: () async {
                          _phoneCall(widget.inTake.workShopNumber.toString());
                        },
                        child: callSection(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth),
                      ),
                    ],
                  ),
                  status
                      ? totalAmountWidget(
                          screenHeight: screenHeight,
                          showRoomAmount: showRoomAmount)
                      : Container(),
                  ElevatedButton(
                      onPressed: () {
                        if (status == false) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Complete show room details!")));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Form(
                                key: _key,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: serviceChargeController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Service charge";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.currency_rupee),
                                    label: Text("AMOUNT PAID"),
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      serviceChargeController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("CANCEL")),
                                ElevatedButton(
                                    onPressed: () {
                                      if (_key.currentState!.validate()) {
                                        WorKShopModel work = WorKShopModel(
                                            car: widget.car,
                                            dateTime: DateTime.now(),
                                            workShopNumber:
                                                widget.inTake.workShopNumber,
                                            serviceAmount: int.parse(
                                                serviceChargeController.text),
                                            workShopName:
                                                widget.inTake.workShopName,
                                            reciptPhoto: billPhoto,
                                            serviceNote: note);
                                        _takeDown(
                                            widget.car,
                                            int.parse(
                                                serviceChargeController.text),
                                            work);
                                        serviceChargeController.clear();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    "Taken back succesfully!")));
                                      }
                                    },
                                    child: const Text("OK"))
                              ],
                            ),
                          );
                        }
                      },
                      child: Text("TAKE BACK"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _phoneCall(String phoneNumber) async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }
    if (status.isGranted) {
      final Uri url = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print("Cannot perform");
      }
    }
  }

  Future<void> _getRecentService(WorKShopModel work) async {
    final works = await WorkshopServices().getCompletedForExp();
    final worksReversed = works.reversed.toList();
    for (var recentWork in worksReversed) {
      if (recentWork.car.vehicleNo == work.car.vehicleNo) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewCompletedWork(
              note: recentWork.serviceNote,
              billImage: recentWork.reciptPhoto.toString(),
              serviceAmount: recentWork.serviceAmount,
              garageName: recentWork.workShopName.toString(),
              phoneNumber: recentWork.workShopNumber,
            ),
          ),
        );
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.red,
          content: Text("No recent service has been made!")),
    );
  }
}
