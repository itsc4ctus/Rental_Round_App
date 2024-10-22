import 'package:flutter/material.dart';

import '../../../View Car/viewcar_screen.dart';
import '../viewCarWorkshop.dart';
import '../workshopScreen.dart';

class CarDetails extends StatelessWidget {
  const CarDetails({
    super.key,
    required this.widget,
  });

  final WorkShopScreen widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewcarScreen(car: widget.car),
            ));
      },
      child: Container(
        child: WorkShopViewCar(
            carName: widget.car.carName,
            vehicleNo: widget.car.vehicleNo,
            kmDriven: widget.car.kmDriven,
            seatCapacity: widget.car.seatCapacity,
            cubicCapacity: widget.car.cubicCapacity,
            rcNo: widget.car.rcNo,
            pollutionDate: widget.car.pollutionDate,
            fuelType: widget.car.fuelType,
            amtPerDay: widget.car.amtPerDay,
            carImage: widget.car.carImage,
            brandName: widget.car.brandName,
            carType: widget.car.carType,
            pcImage: widget.car.pcImage,
            rcImage: widget.car.rcImage),
      ),
    );
  }
}
