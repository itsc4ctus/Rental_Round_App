import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentel_round/Screens/Drawer%20Screens/profile_screen.dart';
import 'package:rentel_round/Screens/Drawer%20Screens/termsandconditions.dart';
import 'package:rentel_round/Screens/Home%20Screen/faqScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Authentication/Screens/new_to_app.dart';
import '../../Models/auth_model.dart';
import '../../Services/auth_services.dart';
import '../../Services/car_services.dart';
import '../../Services/expence_services.dart';
import '../../Services/status_services.dart';
import '../../Services/workshop_services.dart';
import '../Drawer Screens/about_app.dart';
import '../Drawer Screens/privacy_policy.dart';

class SettingsScreen extends StatefulWidget {
  final Auth userProfile;
  const SettingsScreen({required this.userProfile, super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(File(widget.userProfile.image)),
            ),
            const SizedBox(height: 20),

            // Settings Options
            Expanded(
              child: ListView(
                children: [
                  SettingsOptionCard(
                    icon: Icons.person_outline,
                    optionName: "User Profile",
                    page: ProfileScreen(auth: widget.userProfile),
                  ),
                  const SettingsOptionCard(
                    icon: Icons.privacy_tip_outlined,
                    optionName: "Privacy Policy",
                    page: PrivacyPolicy(),
                  ),
                  const SettingsOptionCard(
                    icon: Icons.contact_page_sharp,
                    optionName: "Terms And Conditions",
                    page: TermsAndConditions(),
                  ),
                  const SettingsOptionCard(
                    icon: Icons.help_outline,
                    optionName: "FAQ",
                    page: FaqScreen(),
                  ),
                  const SettingsOptionCard(
                    icon: Icons.info_outline,
                    optionName: "About Us",
                    page: AboutApp(),
                  ),
                  ContactOptionCard(
                    icon: Icons.phone_outlined,
                    optionName: "Contact Us",
                    call: () async {
                      await _phoneCall("7356041058");
                    },
                  ),
                ],
              ),
            ),

            // Logout Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      _showDialogue(
                          "Are you sure you want to close the shop? It will remove all data!",
                          "OK", () async {
                        await CarServices().clearBox();
                        await ExpenceServices().clearBox();
                        await StatusServices().clearBox();
                        await WorkshopServices().clearBox();
                        widget.userProfile.status = false;
                        await AuthServices().updateUser(widget.userProfile);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewToHome()));
                      }, context);
                    },
                    child: const Text("LOGOUT"),
                  ),
                  const SizedBox(height: 10),
                  const Text("Rental Round"),
                  const Text("version: 1.0.0+1"),
                  const Text("All Copyrights Reserved ©"),
                ],
              ),
            )
          ],
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

  void _showDialogue(String message, String btnName, VoidCallback btnfn,
      BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("CANCEL"),
            ),
            ElevatedButton(onPressed: btnfn, child: Text(btnName))
          ],
        );
      },
    );
  }
}

class ContactOptionCard extends StatelessWidget {
  final String optionName;
  final Function call;
  final IconData icon;
  const ContactOptionCard({
    required this.optionName,
    required this.call,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900),
        title: Text(optionName, style: const TextStyle(fontSize: 20)),
        trailing: const Icon(Icons.call, color: Colors.blue),
        onTap: () async {
          await call();
        },
      ),
    );
  }
}

class SettingsOptionCard extends StatelessWidget {
  final String optionName;
  final Widget page;
  final IconData icon;
  const SettingsOptionCard({
    required this.optionName,
    required this.page,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900),
        title: Text(optionName, style: const TextStyle(fontSize: 20)),
        trailing: const Icon(CupertinoIcons.right_chevron),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}
