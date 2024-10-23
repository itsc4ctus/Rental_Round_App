import 'package:flutter/material.dart';

import '../../../../Models/expences_model.dart';
import '../otherExpenseTile.dart';

class addOtherExpenseWidget extends StatelessWidget {
  const addOtherExpenseWidget({
    super.key,
    required this.otherExpList,
  });

  final List<expenses> otherExpList;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        height: 400,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 25,
                      width: 100,
                      child: Text("Date"),
                    ),
                    SizedBox(
                      height: 25,
                      width: 120,
                      child: Text("Expence"),
                    ),
                    SizedBox(
                      height: 25,
                      width: 70,
                      child: Text("Amount"),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: otherExpList.isEmpty
                      ? const Center(
                          child: Text("Add expenses to display here!"),
                        )
                      : ListView.builder(
                          itemCount: otherExpList.length,
                          itemBuilder: (context, index) => Otherexpensetile(
                                dateTime: otherExpList[index].dateTime,
                                expAmt: otherExpList[index].expenceAmt,
                                expType: otherExpList[index].expenceType,
                              )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
