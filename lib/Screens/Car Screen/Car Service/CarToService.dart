import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentel_round/Models/workshop_model.dart';
import 'package:rentel_round/Screens/Car%20Screen/Car%20Service/renew_pollution.dart';
import 'package:rentel_round/Screens/Car%20Screen/View%20Car/viewcar_screen.dart';
import 'package:rentel_round/Services/workshop_services.dart';
import '../../../Models/car_model.dart';

class CarToService extends StatefulWidget {
  final String image;
  final String carName;
  final String brandName;
  final String vNo;
  final DateTime pollutionDate;
  final Function(int phoneNumber, String showRoomNumber) onService;
  final Cars car;

  const CarToService({
    required this.brandName,
    required this.carName,
    required this.image,
    required this.vNo,
    required this.pollutionDate,
    required this.onService,
    required this.car,
    super.key,
  });

  @override
  State<CarToService> createState() => _CarToServiceState();
}

class _CarToServiceState extends State<CarToService> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController showRoomNameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 140,
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
                        builder: (context) => ViewcarScreen(car: widget.car)),
                  );
                },
                child: Image(image: FileImage(File(widget.image))),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.brandName),
                Text(widget.carName),
                Text(widget.vNo),
                Container(
                  child: Column(
                    children: [
                      const Text("Last Date of PC"),
                      Text(
                        "${widget.pollutionDate.day} - ${widget.pollutionDate.month} - ${widget.pollutionDate.year}",
                        style: TextStyle(
                          color: widget.pollutionDate.isAfter(DateTime.now())
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _showServiceList, child: const Text("SERVICE")),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RenewPollution(
                            car: widget.car,
                            pollutionDate: widget.pollutionDate),
                      ),
                    );
                  },
                  child: const Text("RENEW"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showServiceList() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you giving your car to service?"),
        content: Form(
          key: _key,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: showRoomNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter show room name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: "Show Room Name", hintText: "Enter name"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter phone number";
                    }
                    if (value.length != 10) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  },
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: "Show Room Phone Number",
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_key.currentState!.validate()) {
                WorKShopModel inTake = WorKShopModel(
                    car: widget.car,
                    dateTime: DateTime.now(),
                    workShopNumber: int.parse(phoneNumberController.text),
                    workShopName: showRoomNameController.text);
                _collectWorkshopDetails(inTake);
                String showRoomNumber = showRoomNameController.text;
                String phoneInput = phoneNumberController.text;
                int? phoneNumber = int.tryParse(phoneInput);
                if (phoneNumber != null && phoneInput.isNotEmpty) {
                  widget.onService(phoneNumber, showRoomNumber);
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _collectWorkshopDetails(WorKShopModel workshop) async {
    await WorkshopServices().addWorkshop(workshop);
  }
}
