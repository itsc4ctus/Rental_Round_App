import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentel_round/Models/car_model.dart';
import 'package:rentel_round/Screens/Car%20Screen/View%20Car/viewcar_screen.dart';
import 'package:rentel_round/Screens/Customer/bottomsheetcar_tile.dart';
import 'package:rentel_round/Screens/Customer/customerFeilds.dart';
import 'package:rentel_round/Screens/Status/viewImage.dart';
import 'package:rentel_round/Services/car_services.dart';
import 'package:rentel_round/Services/status_services.dart';
import '../../Models/status_model.dart';

class AddScreen extends StatefulWidget {
  final Function(int) goToStatus;
  const AddScreen({required this.goToStatus, super.key});
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime dateNow = DateTime.now();
  DateTime lastdateTime = DateTime.now();
  DateTime? displayDate;
  int? finalAmount;
  List<Cars> listCar = [];
  List<Cars> filteredCars = [];
  Cars? selectedCar;
  late int noOfDays;
  late int noOfHours;
  int? total = 0;
  TextEditingController cnameController = TextEditingController();
  TextEditingController cidController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController noOfDaysController = TextEditingController();
  TextEditingController currentKmController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController extraAmtController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  CustomerFeilds customerFields = CustomerFeilds();
  ImagePicker picker = ImagePicker();
  XFile? proofImg;
  List<String> month = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  @override
  void initState() {
    _loadCars();
    amountController.addListener(_updateAmount);
    searchController.addListener(_updateCarList);
    super.initState();
  }

  @override
  void dispose() {
    cidController.dispose();
    cnameController.dispose();
    currentKmController.dispose();
    amountController.removeListener(_updateAmount);
    searchController.removeListener(_updateCarList);
    endDateController.dispose();
    extraAmtController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  String? monthToWords(int value) {
    String? word;
    setState(() {
      word = month[value - 1];
    });
    return word;
  }

  void _clearFeilds() {
    extraAmtController.text.isEmpty;
    cidController.clear();
    cnameController.clear();
    currentKmController.clear();
    amountController.clear();
    endDateController.clear();
    amountController.clear();
    selectedCar = null;
    proofImg = null;
    lastdateTime = DateTime.now();
    _key.currentState!.reset();
    setState(() {});
  }

  void _loadCars() async {
    List<Cars> car = await CarServices().getAvailableCar();
    setState(() {
      listCar = car;
      filteredCars = car;
    });
  }

  void _updateCarList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredCars = listCar.where((car) {
        return car.carName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _updateAmount() {
    setState(() {});
  }

  void _addStatus(status status) async {
    await StatusServices().addStatus(status);
  }

  void _getStatus() async {
    await StatusServices().getStatus();
  }

  void _pickImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      proofImg = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;

    Duration duration = lastdateTime.difference(dateNow);
    noOfDays = duration.inDays + 1;
    noOfHours = duration.inHours;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ADD NEW CUSTOMER"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: kIsWeb ? screenWidth * 0.8 : null,
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: proofImg == null
                              ? null
                              : () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewImage(image: proofImg!.path),
                                      ));
                                },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: screenHeight * 0.15,
                              width: screenWidth * 0.3,
                              color: Colors.pink.shade50,
                              child: proofImg == null
                                  ? const Center(
                                      child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ))
                                  : Image(
                                      fit: BoxFit.cover,
                                      image: FileImage(File(proofImg!.path))),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _pickImage();
                              },
                              child: const Text(
                                "UPLOAD",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "upload proof photo here",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    customerFields.fields(
                      (value) {
                        if (cnameController.text.isEmpty) {
                          return "Enter a Customer name";
                        }
                        return null;
                      },
                      "customer name",
                      "enter customer name",
                      cnameController,
                    ),
                    const SizedBox(height: 10),
                    customerFields.fields(
                      (value) {
                        if (cidController.text.isEmpty) {
                          return "Enter a Customer Proof ID";
                        }
                        return null;
                      },
                      "customer proof ID",
                      "enter customer proof ID",
                      cidController,
                    ),
                    const SizedBox(height: 10),
                    customerFields.fieldsForAmt(
                      (value) {
                        if (amountController.text.isEmpty) {
                          return "Enter an amount";
                        }
                        return null;
                      },
                      "advanced amount",
                      "enter amount",
                      amountController,
                      TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    customerFields.fieldsForAmt(
                      (value) {
                        if (extraAmtController.text.isEmpty) {
                          return "Enter an amount";
                        }
                        return null;
                      },
                      "extra amount per KM",
                      "enter amount",
                      extraAmtController,
                      TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            filteredCars.isEmpty
                                ? _noCarsAvailable()
                                : _showCars();
                          },
                          child: const Text("Select A Car"),
                        ),
                        selectedCar == null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.pink.shade50,
                                ),
                                height: screenHeight * 0.15,
                                width: screenWidth * 0.3,
                                child: const Icon(CupertinoIcons.car_detailed),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewcarScreen(car: selectedCar!),
                                      ));
                                },
                                child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: SingleChildScrollView(
                                    child: BottomSheetCarTile(
                                      carName: selectedCar!.carName,
                                      vehicleNo: selectedCar!.vehicleNo,
                                      kmDriven: selectedCar!.kmDriven,
                                      seatCapacity: selectedCar!.seatCapacity,
                                      cubicCapacity: selectedCar!.cubicCapacity,
                                      rcNo: selectedCar!.rcNo,
                                      pollutionDate: selectedCar!.pollutionDate,
                                      fuelType: selectedCar!.fuelType,
                                      amtPerDay: selectedCar!.amtPerDay,
                                      carImage: selectedCar!.carImage,
                                      brandName: selectedCar!.brandName,
                                      carType: selectedCar!.carType,
                                      pcImage: selectedCar!.pcImage,
                                      rcImage: selectedCar!.rcImage,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Select End Date:"),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          child: Text(displayDate == null
                              ? "SELECT DATE"
                              : "${displayDate!.day}-${monthToWords(displayDate!.month)}-${displayDate!.year}"),
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 250,
                                  child: CupertinoDatePicker(
                                    minimumDate:
                                        DateTime.now().add(const Duration(days: 1)),
                                    initialDateTime:
                                        DateTime.now().add(const Duration(days: 1)),
                                    onDateTimeChanged: (DateTime newDate) {
                                      setState(() {
                                        displayDate = newDate;
                                        lastdateTime = newDate;
                                        noOfDays = lastdateTime
                                            .difference(dateNow)
                                            .inDays;
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Total Amount:"),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.3,
                          child: amountController.text.isEmpty ||
                                  selectedCar == null
                              ? const Center(
                                  child: Text(
                                      "Enter Advance amount and Select a Car"))
                              : Center(
                                  child: Text(
                                    "₹ ${calculateTotal(noOfDays, amountController, selectedCar!)} for $noOfDays days",
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showDialogue(
                                "Do you want to cancel the process?", "OK", () {
                              _clearFeilds();
                              Navigator.pop(context);
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            }, context);
                          },
                          child: const Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              if (proofImg == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Add Proof Image!")));
                                return;
                              }
                              if (selectedCar == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Select A Car!")));
                                return;
                              }
                              _showDialogue("Click OK to add customer.", "OK",
                                  () {
                                status newStatus = status(
                                  cName: cnameController.text,
                                  cId: cidController.text,
                                  startDate: dateNow,
                                  endDate: lastdateTime,
                                  selectedCar: selectedCar!,
                                  advAmount: int.parse(amountController.text),
                                  extraAmount:
                                      int.parse(extraAmtController.text),
                                  proofImage: proofImg!.path,
                                  totalAmount: calculateTotal(
                                      noOfDays, amountController, selectedCar!),
                                  amountReceived: 0,
                                );
                                _addStatus(newStatus);
                                _getStatus();
                                print(dateNow);
                                moveToOnHold(
                                    selectedCar!, selectedCar!.vehicleNo);
                                Navigator.pop(context);
                                widget.goToStatus(1);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          "New Deal Started!",
                                          style: TextStyle(color: Colors.white),
                                        )));
                              }, context);
                            }
                          },
                          child: const Text(
                            "ADD CUSTOMER",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> moveToOnHold(Cars movingCar, String vehicleNo) async {
    setState(() async {
      await CarServices().deleteAvailableCar(vehicleNo);
      await CarServices().addOnHoldCar(movingCar);
      await CarServices().getAvailableCar();
      await CarServices().getOnHoldCar();
    });
  }

  int calculateTotal(
      int noOfDays, TextEditingController amountController, Cars? selectedCar) {
    if (amountController.text.isEmpty || selectedCar == null) {
      return 0;
    }
    int amtPerDay = selectedCar.amtPerDay;
    int total = (amtPerDay * noOfDays);
    return total;
  }

  Future _noCarsAvailable() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return const Center(
          child: Text("No Cars are available"),
        );
      },
    );
  }

  Future _showCars() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(CupertinoIcons.search_circle)),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: filteredCars.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedCar = filteredCars[index];
                        });
                        Navigator.pop(context);
                      },
                      child: BottomSheetCarTile(
                        carName: filteredCars[index].carName,
                        vehicleNo: filteredCars[index].vehicleNo,
                        kmDriven: filteredCars[index].kmDriven,
                        seatCapacity: filteredCars[index].seatCapacity,
                        cubicCapacity: filteredCars[index].cubicCapacity,
                        rcNo: filteredCars[index].rcNo,
                        pollutionDate: filteredCars[index].pollutionDate,
                        fuelType: filteredCars[index].fuelType,
                        amtPerDay: filteredCars[index].amtPerDay,
                        carImage: filteredCars[index].carImage,
                        brandName: filteredCars[index].brandName,
                        carType: filteredCars[index].carType,
                        pcImage: filteredCars[index].pcImage,
                        rcImage: filteredCars[index].rcImage,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialogue(String messege, String btnName, VoidCallback btnfn,
      BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(messege),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CANCEL")),
              ElevatedButton(onPressed: btnfn, child: Text(btnName))
            ],
          );
        });
  }
}
