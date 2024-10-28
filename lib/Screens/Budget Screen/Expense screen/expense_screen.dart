import 'package:flutter/material.dart';
import 'package:rentel_round/Models/auth_model.dart';
import 'package:rentel_round/Models/expences_model.dart';
import 'package:rentel_round/Models/workshop_model.dart';
import 'package:rentel_round/Screens/Budget%20Screen/Add%20other%20expense%20screen/add_other_expense_screen.dart';
import 'package:rentel_round/Screens/Budget%20Screen/Expense%20screen/sections/otherExpenseSection.dart';
import 'package:rentel_round/Screens/Budget%20Screen/Expense%20screen/sections/servicedCarsSection.dart';
import 'package:rentel_round/Screens/Navbar%20Screen/navbar.dart';
import 'package:rentel_round/Services/car_services.dart';
import 'package:rentel_round/Services/expence_services.dart';
import 'package:rentel_round/Services/workshop_services.dart';

import '../../../Models/car_model.dart';

class ExpenseScreen extends StatefulWidget {
  final Auth auth;
  const ExpenseScreen({required this.auth, super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    getServicedCar();
    getOtherExp();
    getList();
    print("Ininit State worked");
    // TODO: implement initState
    super.initState();
  }

  List<WorKShopModel> workshopList = [];
  List<Cars> servicedCars = [];
  List<expenses> otherExpList = [];
  late Auth auth;
  Future<void> getServicedCar() async {
    List<Cars> cars = await CarServices().getExpSerCar();
    setState(() {
      servicedCars = cars;
    });
  }

  Future<void> getOtherExp() async {
    otherExpList = await ExpenceServices().getExpenses();
    setState(() {});
  }

  Future<void> getList() async {
    workshopList = await WorkshopServices().getCompletedForExp();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("EXPENSES"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavBar(
                      auth: widget.auth,
                      index: 4,
                    ),
                  ),
                  (route) => false,
                );
                setState(() {});
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("CAR'S SERVICE EXPENSES:"),
              ),
              RecentServicedCarsList(workshopList: workshopList),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("OTHER EXPENSES:"),
              ),
              addOtherExpenseWidget(otherExpList: otherExpList),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherExpScreen(
                            auth: widget.auth,
                          ),
                        ));
                  },
                  child: const Text("ADD OTHER EXPENSES")),
            ],
          ),
        ),
      ),
    );
  }
}
