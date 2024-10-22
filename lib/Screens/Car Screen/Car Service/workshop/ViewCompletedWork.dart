import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentel_round/Screens/Status/viewImage.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCompletedWork extends StatefulWidget {
  const ViewCompletedWork({
    required this.note,
    required this.billImage,
    required this.serviceAmount,
    required this.garageName,
    required this.phoneNumber,
    super.key,
  });
  final int phoneNumber;
  final String garageName;
  final String billImage;
  final String note;
  final int serviceAmount;

  @override
  State<ViewCompletedWork> createState() => _ViewCompletedWorkState();
}

class _ViewCompletedWorkState extends State<ViewCompletedWork> {
  late int phoneNumber;
  @override
  void initState() {
    phoneNumber = widget.phoneNumber;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.garageName),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Garage Name and Contact Section
              Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.garageName}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "$phoneNumber",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          _phoneCall(widget.phoneNumber.toString());
                        },
                        icon: const Icon(Icons.phone),
                        color: Colors.green,
                        iconSize: 28,
                      ),
                    ],
                  ),
                ),
              ),

              // Receipt Image Section
              Card(
                color: Colors.blue.shade900,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const Text(
                        "Receipt",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewImage(image: widget.billImage),
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: kIsWeb
                              ? Container(
                                  child: Icon(Icons.image),
                                )
                              : (Image.file(
                                  File(widget.billImage),
                                  height: screenHeight * 0.30,
                                  width: screenWidth * 0.6,
                                  fit: BoxFit.cover,
                                )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Note Section
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  height: 200,
                  width: screenWidth * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.note,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),

              // Amount Paid Section
              Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "AMOUNT PAID:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "₹ ${widget.serviceAmount}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
}
