import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rentel_round/Screens/Budget%20Screen/Budget%20screen/widget/cards/budget_screen_card.dart';
import 'package:rentel_round/Screens/Budget%20Screen/Expense%20screen/expense_screen.dart';
import 'package:rentel_round/Screens/Budget%20Screen/Budget%20screen/latestdeals.dart';
import 'package:rentel_round/Screens/Budget%20Screen/Budget%20screen/Deals/showCDeals.dart';
import 'package:rentel_round/Screens/Car%20Screen/View%20Car/viewcartiles.dart';
import 'package:rentel_round/Services/expence_services.dart';
import 'package:rentel_round/Services/status_services.dart';
import 'package:rentel_round/Services/workshop_services.dart';

import '../../../Models/auth_model.dart';
import '../../../Models/expences_model.dart';
import '../../../Models/status_model.dart';
import '../../../Models/workshop_model.dart';

class BudgetScreen extends StatefulWidget {
  final Auth auth;
  BudgetScreen({required this.auth, super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  int totalIncome = 0;
  int totalExpense = 0;
  int totalServiceCharges = 0;
  int totalOtherExp = 0;
  int profit = 0;
  List<status> CStatusList = [];
  List<String> periods = ["Last 7 days", "Last one month", "Last year"];
  String selectedPeriod = "Last year";
  @override
  void initState() {
    _loadCompletedStatus();
    super.initState();
  }

  Future<void> _loadCompletedStatus() async {
    totalIncome = 0;
    totalExpense = 0;
    totalOtherExp = 0;
    totalServiceCharges = 0;
    profit = 0;
    List<status> list = await StatusServices().getCompletedDealStatus();
    CStatusList = list;
    CStatusList = CStatusList.reversed.toList();
    for (var Status in CStatusList) {
      if (Status.startDate.isAfter(_startDate) &&
          Status.endDate.isBefore(_endDate.add(Duration(days: 1)))) {
        totalIncome = totalIncome + Status.amountReceived;
      }
    }
    List<WorKShopModel> workshopList =
        await WorkshopServices().getCompletedForExp();
    for (var work in workshopList) {
      if (work.dateTime.isAfter(_startDate) &&
          work.dateTime.isBefore(_endDate.add(Duration(days: 1)))) {
        totalServiceCharges = totalServiceCharges + work.serviceAmount;
      }
    }
    List<expenses> expList = await ExpenceServices().getExpenses();
    for (var expense in expList) {
      if (expense.dateTime.isAfter(_startDate) &&
          expense.dateTime.isBefore(_endDate.add(Duration(days: 1)))) {
        totalOtherExp = totalOtherExp + expense.expenceAmt;
      }
    }
    totalExpense = totalServiceCharges + totalOtherExp;
    profit = totalIncome - totalExpense;
    setState(() {});
  }

  void dropdownPicker(String newPeriod) {
    setState(() {
      if (newPeriod == "Last 7 days") {
        _startDate = DateTime.now().subtract(Duration(days: 7));
      } else if (newPeriod == "Last one month") {
        _startDate = DateTime.now().subtract(Duration(days: 30));
      } else if (newPeriod == "Last year") {
        _startDate = DateTime.now().subtract(Duration(days: 365));
      }
      _endDate = DateTime.now();
      _loadCompletedStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("RENTEL ROUND"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("BUDGET TRACKER"),
              ),
              Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: kIsWeb ? screenWidth * 0.7 : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("SELECT PERIOD"),
                                actions: [
                                  Container(
                                    child: Row(
                                      children: [
                                        DropdownButton<String>(
                                            value: selectedPeriod,
                                            items: periods
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              selectedPeriod = newValue!;
                                              dropdownPicker(selectedPeriod);
                                              Navigator.pop(context);
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                              child: Row(
                            children: [
                              ViewCarTiles().viewDateTwo(_startDate),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("To"),
                              ),
                              ViewCarTiles().viewDateTwo(_endDate),
                              Icon(Icons.arrow_drop_down),
                            ],
                          )),
                        ),
                        IconButton(
                            onPressed: () {
                              _showDateTimePicker();
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: Colors.blue.shade900,
                            )),
                      ],
                    ),
                  )),
              budgetCard.buildInfoCard(
                title: "TOTAL INCOME",
                subtitle: "",
                child: Column(
                  children: [
                    budgetCard.buildStatCard(
                        "TOTAL INCOME", totalIncome.toString()),
                    budgetCard.buildStatCard(
                        "TOTAL EXPENSE", totalExpense.toString()),
                    const Divider(color: Colors.blue),
                    budgetCard.buildStatCardforProfit("PROFIT", profit),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              budgetCard.buildInfoCard(
                title: "LATEST DEALS",
                subtitle: "",
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(border: Border.all()),
                  child: CStatusList.isEmpty
                      ? const Center(child: Text("No Deals to show"))
                      : ListView.builder(
                          itemCount:
                              CStatusList.length > 7 ? 7 : CStatusList.length,
                          itemBuilder: (context, index) => LatestDeals(
                            cName: CStatusList[index].cName,
                            amountRecieved: CStatusList[index].amountReceived,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShowCDeals()));
                  },
                  child: const Text("SHOW ALL DEALS"),
                ),
              ),
              const SizedBox(height: 5),
              budgetCard.buildInfoCard(
                title: "EXPENSES",
                subtitle: "",
                child: Column(
                  children: [
                    budgetCard.buildStatCard(
                        "SERVICE CHARGES", totalServiceCharges.toString()),
                    budgetCard.buildStatCard(
                        "OTHER EXPENSES", totalOtherExp.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExpenseScreen(auth: widget.auth),
                        ));
                  },
                  child: const Text("EXPENSE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? pickedStartDate = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (pickedStartDate != null) {
      setState(() {
        _startDate = pickedStartDate;
      });
    }
    final DateTime? pickedEndDate = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: _startDate,
        lastDate: DateTime.now());
    if (pickedEndDate != null) {
      setState(() {
        _endDate = pickedEndDate;
      });
    }
    _loadCompletedStatus();
  }
}
