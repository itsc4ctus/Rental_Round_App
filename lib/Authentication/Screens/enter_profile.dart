import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentel_round/Authentication/Screens/Sign-Up/signupfeild.dart';
import 'package:rentel_round/Models/auth_model.dart';
import 'package:rentel_round/Screens/Navbar%20Screen/navbar.dart';
import 'package:rentel_round/Services/auth_services.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

TextEditingController shopnameController = TextEditingController();
TextEditingController shopownernameController = TextEditingController();
TextEditingController shoplocationController = TextEditingController();
TextEditingController shopphonenoController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController cpasswordController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey();
XFile? img;

class _AddProfileState extends State<AddProfile> {
  SignUpFeilds feilds = SignUpFeilds();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Uint8List? profileImg;
  Future<void> pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.first.bytes != null) {
        setState(() {
          profileImg = result.files.first.bytes;
        });
      }
    } else {
      final XFile? pickedimg =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedimg != null) {
        setState(() {
          _image = pickedimg;
        });
      }
    }
  }

  @override
  void dispose() {
    shopnameController.clear();
    shopownernameController.clear();
    emailController.clear();
    shoplocationController.clear();
    shopphonenoController.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "OPEN YOUR SHOP",
          style: TextStyle(fontFamily: "fredoka"),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: kIsWeb ? screenWidth * 0.5 : null,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: 80,
                        width: 80,
                        color: Colors.purple.shade100,
                        child: !kIsWeb
                            ? (_image == null
                                ? const Icon(Icons.image)
                                : Image(image: FileImage(File(_image!.path))))
                            : (profileImg == null
                                ? const Icon(Icons.image)
                                : Image.memory(profileImg!))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await pickImage();
                    },
                    child: const Text(
                      "UPLOAD",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  feilds.feild(
                      "shop name", "enter your shop name", shopnameController,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid name';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  feilds.feild("shop owner name", "enter your shop owner name",
                      shopownernameController, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid shop owner name';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  feilds.feild("shop location", "enter your shop location",
                      shoplocationController, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a location';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  feilds.feild("phone number", "enter your phone number",
                      shopphonenoController, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid phone number';
                    }
                    if (value.length != 10) {
                      return 'Enter A 10 digit number';
                    }
                    return null;
                  }, TextInputType.phone,
                      [FilteringTextInputFormatter.digitsOnly]),
                  const SizedBox(
                    height: 10,
                  ),
                  feilds.feild(
                    "email",
                    "enter your email",
                    emailController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (kIsWeb) {
                        if (profileImg == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Upload an image")));
                          return;
                        }
                      }
                      if (!kIsWeb) {
                        if (_image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Upload an image")));
                          return;
                        }
                      }

                      if (_formKey.currentState!.validate()) {
                        _showDialogue("Click OK to OPEN YOUR SHOP", "OK",
                            () async {
                          Auth auth = Auth(
                            shopname: shopnameController.text,
                            shopownername: shopownernameController.text,
                            shoplocation: shoplocationController.text,
                            phonenumer: int.parse(shopphonenoController.text),
                            email: emailController.text,
                            image:
                                kIsWeb ? profileImg.toString() : _image!.path,
                            status: true,
                          );
                          await AuthServices().addUser(auth);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavBar(
                                      auth: auth,
                                    )),
                            (route) => false,
                          );
                        }, context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please fill the above details!")));
                      }
                    },
                    child: const Text(
                      "OPEN SHOP",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
