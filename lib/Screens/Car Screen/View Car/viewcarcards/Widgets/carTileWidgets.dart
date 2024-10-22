import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../car_tile.dart';

class EditCarButton extends StatelessWidget {
  const EditCarButton({
    super.key,
    required this.widget,
  });

  final CarTile widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onEdit,
      icon: const Icon(
        Icons.edit,
        color: Colors.blue,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
      ),
    );
  }
}

class viewCarButton extends StatelessWidget {
  const viewCarButton({
    super.key,
    required this.widget,
  });

  final CarTile widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.viewCar,
      icon: const Icon(
        CupertinoIcons.car_detailed,
        color: Colors.black,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
      ),
    );
  }
}

class carImageWidget extends StatelessWidget {
  const carImageWidget({
    super.key,
    required this.widget,
  });

  final CarTile widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      height: 140,
      width: 280,
      child: Image(image: FileImage(File(widget.carImage))),
    );
  }
}

class availabilityWidget extends StatelessWidget {
  const availabilityWidget({
    super.key,
    required this.widget,
  });

  final CarTile widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: widget.availability ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
