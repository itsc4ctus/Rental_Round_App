import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Models/expences_model.dart';
import '../../../../Models/workshop_model.dart';
import '../otherExpenseTile.dart';
import '../workshopTile.dart';

class RecentServicedCarsList extends StatelessWidget {
  const RecentServicedCarsList({
    super.key,
    required this.workshopList,
  });

  final List<WorKShopModel> workshopList;

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
        child: workshopList.isEmpty
            ? Center(
                child: Text("No cars to display!"),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: workshopList.length,
                  itemBuilder: (context, index) => WorkShoptile(
                    workshop: workshopList[index],
                  ),
                ),
              ),
      ),
    );
  }
}
