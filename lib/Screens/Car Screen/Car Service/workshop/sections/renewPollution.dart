import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../renew_pollution.dart';
import '../workshopScreen.dart';

class renewPollutionSection extends StatelessWidget {
  const renewPollutionSection({
    super.key,
    required this.widget,
    required this.screenHeight,
    required this.screenWidth,
  });

  final WorkShopScreen widget;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RenewPollution(
                car: widget.car,
                pollutionDate: widget.car.pollutionDate,
              ),
            ));
      },
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade900),
              height: screenHeight * 0.1,
              width: screenWidth * 0.2,
              child: Icon(
                size: kIsWeb ? screenWidth * 0.040 : screenWidth * 0.1,
                Icons.autorenew_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const Text("RENEW\nPOLLUTION")
        ],
      ),
    );
  }
}
