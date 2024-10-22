import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ShowRoomService extends StatefulWidget {
  ShowRoomService(
      {required this.phoneNumber, required this.shopName, super.key});
  final int phoneNumber;
  final String shopName;

  @override
  State<ShowRoomService> createState() => _ShowRoomServiceState();
}

class _ShowRoomServiceState extends State<ShowRoomService> {
  TextEditingController showRoomAmountController = TextEditingController();
  TextEditingController notecontroller = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  XFile? billimage;
  Uint8List? webBillImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _picKImage() async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.first.bytes != null) {
        setState(() {
          webBillImage = result.files.first.bytes;
        });
      }
    } else {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        billimage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Showroom Service",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Garage Information
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.shopName,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Phone:"),
                          Text(
                            widget.phoneNumber.toString(),
                            style:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight * 0.2,
                        width: screenWidth * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: kIsWeb
                            ? (webBillImage == null
                                ? Center(
                                    child: Text("Add Bill Image",
                                        style: TextStyle(color: Colors.grey)))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(webBillImage!),
                                  ))
                            : (billimage == null
                                ? Center(
                                    child: Text("Add Bill Image",
                                        style: TextStyle(color: Colors.grey)))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(billimage!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _picKImage,
                        icon: Icon(Icons.photo_camera),
                        label: Text("Add Bill Photo"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text("Service Note"),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter note";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: notecontroller,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Add any notes here...",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 15.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Column(
                    children: [
                      Text("Add Serviced amount"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter amount";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: showRoomAmountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: "Amount",
                            hintText: "Enter Amount",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (kIsWeb
                              ? webBillImage == null
                              : billimage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Add bill image")));
                          } else {
                            if (_key.currentState!.validate()) {
                              final data = {
                                'billPhoto': billimage?.path,
                                'note': notecontroller.text,
                                'amount':
                                    int.parse(showRoomAmountController.text),
                                'status': true,
                              };
                              Navigator.pop(context, data);
                            }
                          }
                        },
                        child: Text("ADD"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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
